import cv2
import os
import shutil
import numpy as np
from ultralytics import YOLO

class CricketBallTracker:
    def __init__(self, video_path, ball_model_path, pitch_model_path, pitch_image_path, frame_dir='Frame', processed_frame_dir='Frame_b'):
        self.video_path = video_path
        self.ball_model = YOLO(ball_model_path)
        self.pitch_model = YOLO(pitch_model_path)
        self.pitch_image_path = pitch_image_path
        self.frame_dir = frame_dir
        self.processed_frame_dir = processed_frame_dir
        self.trajectory_points = []
        self.fps = None
        self.src_points = None 
        self.dst_points = [(54, 57), (192, 57), (54, 545), (192, 547)]
        self.homography_matrix = None

    @staticmethod
    def cleanup_directories(directories):
        """ Cleans up directories for fresh processing. """
        for directory in directories:
            if os.path.exists(directory):
                shutil.rmtree(directory)
            os.makedirs(directory, exist_ok=True)

    def define_homography(self):
        """ Calculate homography matrix using detected pitch coordinates. """
        if self.src_points:
            self.homography_matrix, _ = cv2.findHomography(np.array(self.src_points), np.array(self.dst_points), cv2.RANSAC, 5.0)
            np.save('homography_matrix.npy', self.homography_matrix)
            print("Homography matrix saved!")
        else:
            print("Error: Source points not defined!")

    def detect_pitch_from_first_frame(self):
        """ Runs pitch detection on the first frame to extract coordinates. """
        first_frame_path = os.path.join(self.frame_dir, "0.png")
        if not os.path.exists(first_frame_path):
            print("First frame not found!")
            return None

        # Read first frame
        frame = cv2.imread(first_frame_path)

        # Run pitch detection model
        results = self.pitch_model(frame)
        detected_pitches = []
        for result in results:
            for box in result.boxes.xyxy:
                x1, y1, x2, y2 = map(int, box[:4])
                detected_pitches.append((x1, y1, x2, y2))

        if detected_pitches:
            # Extract first detected pitch box
            (x1, y1, x2, y2) = detected_pitches[0]
            return [
                (x1, y1),  # Top Left
                (x2, y1),  # Top Right
                (x1, y2),  # Bottom Left
                (x2, y2)   # Bottom Right
            ]
        return None

    def process_video(self):
        """ Processes video, saves frames, and detects the ball. """
        cap = cv2.VideoCapture(self.video_path)
        if not cap.isOpened():
            print("Error opening video stream or file")
            return

        self.fps = cap.get(cv2.CAP_PROP_FPS)
        self.cleanup_directories([self.frame_dir, self.processed_frame_dir])

        frame_count = 0
        pitch_detected = False

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            frame_path = f'{self.frame_dir}/{frame_count}.png'
            cv2.imwrite(frame_path, frame)

           
            if frame_count == 0 and not pitch_detected:
                detected_coords = self.detect_pitch_from_first_frame()
                if detected_coords:
                    print("🏏 Detected Pitch Coordinates:", detected_coords)
                    self.src_points = detected_coords
                    self.define_homography()
                    pitch_detected = True
                else:
                    print("Pitch detection failed.")

            
            results = self.ball_model(frame)
            detected_balls = []

            for result in results:
                for box in result.boxes.xyxy:
                    x1, y1, x2, y2 = map(int, box[:4])
                    center = ((x1 + x2) // 2, (y1 + y2) // 2)
                    radius = max((x2 - x1) // 2, (y2 - y1) // 2)
                    detected_balls.append((center, radius))

            if detected_balls:
                # Track the largest detected ball
                largest_ball = max(detected_balls, key=lambda x: x[1])
                largest_center, largest_radius = largest_ball
                self.trajectory_points.append(largest_center)
                cv2.circle(frame, largest_center, largest_radius, (0, 255, 0), 2)

            # Save processed frame
            cv2.imwrite(f'{self.processed_frame_dir}/processed_frame_{frame_count}.png', frame)
            frame_count += 1

        cap.release()
        cv2.destroyAllWindows()

        np.save('ball_trajectory.npy', self.trajectory_points)
        print("Ball trajectory saved!")

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

        # Clip points to stay within the pitch image
        mapped_points[0][:, 0] = np.clip(mapped_points[0][:, 0], 0, pitch_width - 1)  # X-axis
        mapped_points[0][:, 1] = np.clip(mapped_points[0][:, 1], 0, pitch_height - 1)  # Y-axis

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
            color = (0, 0, 255)  # Red for all points

            cv2.circle(pitch, (x, y), 5, color, -1)

            # Connect points with lines
            if i > 0:
                prev_point = mapped_points[0][i - 1]
                prev_x, prev_y = int(prev_point[0]), int(prev_point[1])
                cv2.line(pitch, (prev_x, prev_y), (x, y), (0, 0, 255), 5) # Red Line Trajectory

        cv2.imwrite('mapped_trajectory_on_pitch.png', pitch)
        cv2.destroyAllWindows()
