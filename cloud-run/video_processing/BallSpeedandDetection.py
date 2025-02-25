import cv2
import numpy as np
import os
import re
import shutil
import matplotlib.pyplot as plt

class BallTracking:
    def __init__(self, video_path, frame_dir='Frame', processed_frame_dir='Frame_b'):
        self.video_path = video_path
        self.frame_dir = frame_dir
        self.processed_frame_dir = processed_frame_dir
        self.trajectory_points = []
        self.heights = []
        self.fps = None
        self.time_between_frames = None

    @staticmethod
    def calculate_displacement(point1, point2, pixel_to_distance_ratio):
        dx = (point2[0] - point1[0]) * pixel_to_distance_ratio
        dy = (point2[1] - point1[1]) * pixel_to_distance_ratio
        return (dx**2 + dy**2)**0.5

    @staticmethod
    def cleanup_directories(directories):
        for directory in directories:
            if os.path.exists(directory):
                shutil.rmtree(directory)
            os.makedirs(directory, exist_ok=True)

    def process_video(self):
        cap = cv2.VideoCapture(self.video_path)
        if not cap.isOpened():
            print("Error opening video stream or file")
            return

        self.fps = cap.get(cv2.CAP_PROP_FPS)
        self.time_between_frames = 1 / self.fps

        self.cleanup_directories([self.frame_dir, self.processed_frame_dir])

        cnt = 0
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            roi = frame
            cv2.imwrite(f'{self.frame_dir}/{cnt}.png', roi)

            image_hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

            lower1 = np.array([0, 100, 0])
            upper1 = np.array([10, 255, 255])
            lower2 = np.array([160, 100, 20])
            upper2 = np.array([180, 255, 255])

            lower_mask = cv2.inRange(image_hsv, lower1, upper1)
            upper_mask = cv2.inRange(image_hsv, lower2, upper2)
            full_mask = lower_mask + upper_mask

            result = cv2.bitwise_and(frame, frame, mask=full_mask)

            contours, _ = cv2.findContours(full_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

            detected_circles = []
            for c in contours:
                blob_area = cv2.contourArea(c)
                blob_perimeter = cv2.arcLength(c, True)

                if blob_perimeter != 0:
                    blob_circularity = (4 * 3.1416 * blob_area) / (blob_perimeter**2)
                    min_circularity = 0.2
                    min_area = 35

                    (x, y), radius = cv2.minEnclosingCircle(c)
                    center = (int(x), int(y))
                    radius = int(radius)

                    if blob_circularity > min_circularity and blob_area > min_area:
                        detected_circles.append([center, radius, blob_area, blob_circularity])

            if detected_circles:
                largest_blob = max(detected_circles, key=lambda x: x[2] * x[3])
                largest_center, largest_radius, _, _ = largest_blob

                self.trajectory_points.append(largest_center)

                pixel_to_height_ratio = 0.01
                height = largest_center[1] * pixel_to_height_ratio
                self.heights.append(height)

                cv2.circle(frame, largest_center, largest_radius, (255, 0, 0), 2)
                cv2.rectangle(frame,
                              (largest_center[0] - largest_radius, largest_center[1] - largest_radius),
                              (largest_center[0] + largest_radius, largest_center[1] + largest_radius),
                              (0, 255, 0), 2)

            cv2.imwrite(f'{self.processed_frame_dir}/processed_frame_{cnt}.png', frame)
            cnt += 1

        cap.release()
        cv2.destroyAllWindows()

    def calculate_speeds(self):
        if len(self.trajectory_points) > 1:
            pixel_to_distance_ratio = 0.01
            speeds = []

            for i in range(1, len(self.trajectory_points)):
                displacement = self.calculate_displacement(self.trajectory_points[i-1], self.trajectory_points[i], pixel_to_distance_ratio)
                speed = (displacement / self.time_between_frames) * 3.6
                speeds.append(speed)

            print("Ball Speed:", np.mean(speeds), "km/h")
            print("Ball Height:", np.mean(self.heights), "meters")
        else:
            print("Not enough points detected to calculate speed and height.")

    def create_output_video(self, output_filename='output_video.mp4'):
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')
        frames = sorted(os.listdir(self.processed_frame_dir), key=lambda x: int(re.sub('\\D', '', x)))

        first_frame = cv2.imread(os.path.join(self.processed_frame_dir, frames[0]))
        height, width, _ = first_frame.shape
        size = (width, height)

        out = cv2.VideoWriter(output_filename, fourcc, self.fps, size)
        for frame_filename in frames:
            frame = cv2.imread(os.path.join(self.processed_frame_dir, frame_filename))
            out.write(frame)

        out.release()
        print(f"Video saved as {output_filename}")