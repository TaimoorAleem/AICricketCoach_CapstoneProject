import cv2
import numpy as np
import os
import shutil
from ultralytics import YOLO
import matplotlib.pyplot as plt

class CricketBallTracker:
    def __init__(self, video_path, model_path, pitch_image_path, frame_dir='Frame', processed_frame_dir='Frame_b'):
        self.video_path = video_path
        self.model = YOLO(model_path)
        self.pitch_image_path = pitch_image_path
        self.frame_dir = frame_dir
        self.processed_frame_dir = processed_frame_dir
        self.trajectory_points = []
        self.fps = None
        self.src_points = []
        #self.dst_points = []
        self.dst_points = [(53, 17), (192, 17), (54, 585), (193, 586)]
        self.homography_matrix = None

    @staticmethod
    def cleanup_directories(directories):
        for directory in directories:
            if os.path.exists(directory):
                shutil.rmtree(directory)
            os.makedirs(directory, exist_ok=True)

    def select_points(self, event, x, y, flags, param):
        if event == cv2.EVENT_LBUTTONDOWN:
            if len(self.src_points) < 4:
                self.src_points.append([x, y])
                cv2.circle(self.frame, (x, y), 5, (0, 0, 255), -1)
            elif len(self.dst_points) < 4:
                self.dst_points.append([x, y])
                cv2.circle(self.pitch_image, (x, y), 5, (0, 255, 0), -1)

    def define_homography(self):
        cap = cv2.VideoCapture(self.video_path)
        ret, self.frame = cap.read()
        cap.release()
        self.pitch_image = cv2.imread(self.pitch_image_path)

        cv2.namedWindow('Select Source Points')
        cv2.setMouseCallback('Select Source Points', self.select_points)

        while len(self.src_points) < 4:
            cv2.imshow('Select Source Points', self.frame)
            if cv2.waitKey(1) & 0xFF == 27:
                break

        cv2.destroyAllWindows()

        self.homography_matrix, _ = cv2.findHomography(np.array(self.src_points), np.array(self.dst_points), cv2.RANSAC, 5.0)
        np.save('homography_matrix.npy', self.homography_matrix)
        print("Homography matrix saved!")

    def process_video(self):
        cap = cv2.VideoCapture(self.video_path)
        if not cap.isOpened():
            print("Error opening video stream or file")
            return

        self.fps = cap.get(cv2.CAP_PROP_FPS)
        self.cleanup_directories([self.frame_dir, self.processed_frame_dir])

        frame_count = 0
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            frame_path = f'{self.frame_dir}/{frame_count}.png'
            cv2.imwrite(frame_path, frame)

            results = self.model(frame)
            detected_balls = []

            for result in results:
                for box in result.boxes.xyxy:
                    x1, y1, x2, y2 = map(int, box[:4])
                    center = ((x1 + x2) // 2, (y1 + y2) // 2)
                    radius = max((x2 - x1) // 2, (y2 - y1) // 2)
                    detected_balls.append((center, radius))

            if detected_balls:
                largest_ball = max(detected_balls, key=lambda x: x[1])
                largest_center, largest_radius = largest_ball
                self.trajectory_points.append(largest_center)
                cv2.circle(frame, largest_center, largest_radius, (0, 255, 0), 2)

            cv2.imwrite(f'{self.processed_frame_dir}/processed_frame_{frame_count}.png', frame)
            frame_count += 1

        cap.release()
        cv2.destroyAllWindows()

        np.save('ball_trajectory.npy', self.trajectory_points)
        print("Ball trajectory saved!")

    # def map_trajectory_to_pitch(self):
    #     pitch = cv2.imread(self.pitch_image_path)
    #     H = np.load('homography_matrix.npy')
    #     trajectory_points = np.load('ball_trajectory.npy')

    #     points = np.array([trajectory_points], dtype='float32')

    #     mapped_points = cv2.perspectiveTransform(points, H)

    #     for i, point in enumerate(mapped_points[0]):
    #         x, y = int(point[0]), int(point[1])

    #         # Check for out of bounds on the last element (i+1) and first element (i-1)
    #         if i > 0 and i < len(trajectory_points) - 1:
    #             # Compare the current point with previous and next to determine color
    #             color = (0, 255, 255) if trajectory_points[i][1] > trajectory_points[i-1][1] and trajectory_points[i][1] < trajectory_points[i+1][1] else (0, 0, 255)
    #         else:
    #             color = (0, 0, 255)  # Default color for the first and last points

    #         cv2.circle(pitch, (x, y), 5, color, -1)

    #     cv2.imshow('Mapped Trajectory on Pitch', pitch)
    #     cv2.imwrite('mapped_trajectory_on_pitch.png', pitch)
    #     cv2.waitKey(0)
    #     cv2.destroyAllWindows()

    def map_trajectory_to_pitch(self):
        # Check if 'bounce_coords.txt' exists and delete it
        if os.path.exists('bounce_coords.txt'):
            os.remove('bounce_coords.txt')

        pitch = cv2.imread(self.pitch_image_path)
        H = np.load('homography_matrix.npy')
        trajectory_points = np.load('ball_trajectory.npy')

        points = np.array([trajectory_points], dtype='float32')
        mapped_points = cv2.perspectiveTransform(points, H)

        # Pitch dimensions
        pitch_height, pitch_width = pitch.shape[:2]

        # Find the lowest bounce point (smallest Y = top of pitch)
        lowest_bounce_idx = None
        min_y = float('inf')  # Start with a large value to find the smallest Y-coordinate

        # Check mapped points before clipping
        for i, point in enumerate(mapped_points[0]):
            x, y = point[0], point[1]
            # Only consider points that are within pitch bounds before clipping
            if 0 <= x < pitch_width and 0 <= y < pitch_height:
                if y < min_y:  # Find the smallest Y (the lowest bounce point)
                    min_y = y
                    lowest_bounce_idx = i

        if lowest_bounce_idx is None:
            print("No valid bounce point found within pitch boundaries!")
            return

        # Clip points to stay within the pitch image
        mapped_points[0][:, 0] = np.clip(mapped_points[0][:, 0], 0, pitch_width - 1)  # X-axis
        mapped_points[0][:, 1] = np.clip(mapped_points[0][:, 1], 0, pitch_height - 1)  # Y-axis

        print(f"Lowest Bounce Point Index: {lowest_bounce_idx}, Y-Coordinate: {min_y}")

        # Debugging: Print all mapped points
        print("All Mapped Points:")
        for i, point in enumerate(mapped_points[0]):
            print(f"Point {i}: ({point[0]}, {point[1]})")
            # Save each point to the text file
            with open('bounce_coords.txt', 'a') as f:
                f.write(f"{point[0]},{point[1]}\n")  # Append x,y coordinates

        # Mark trajectory points
        for i, point in enumerate(mapped_points[0]):
            x, y = int(point[0]), int(point[1])
            if i == lowest_bounce_idx:
                color = (0, 255, 255)  # Yellow for lowest bounce
                print(f"Marking lowest bounce point at: ({x}, {y}) in yellow")
            else:
                color = (0, 0, 255)  # Red for other points

            cv2.circle(pitch, (x, y), 5, color, -1)

            # Connect points with lines
            if i > 0:
                prev_point = mapped_points[0][i - 1]
                prev_x, prev_y = int(prev_point[0]), int(prev_point[1])
                cv2.line(pitch, (prev_x, prev_y), (x, y), (0, 255, 0), 2)  # Green line for trajectory

        # Show and save the image
        cv2.imshow('Mapped Trajectory on Pitch', pitch)
        cv2.imwrite('mapped_trajectory_on_pitch.png', pitch)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

if __name__ == "__main__":
    video_path = 'NetPractice8.mp4'
    model_path = os.path.join('runs', 'detect', 'train8', 'weights', 'best.pt')
    pitch_image_path = 'pitch.jpeg'

    tracker = CricketBallTracker(video_path, model_path, pitch_image_path)
    tracker.define_homography()
    tracker.process_video()
    tracker.map_trajectory_to_pitch()

