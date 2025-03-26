# import cv2
# import os
# import numpy as np

# class CricketBallTracker:
#     def __init__(self, frame_dir='Frame_b', scale_factor=0.05, speed_threshold=100):
#         self.frame_dir = frame_dir  # Processed frames from BallTrackingandMapping
#         self.scale_factor = scale_factor  # Scaling factor to convert pixels to real-world units
#         self.speed_threshold = speed_threshold  # Threshold to ignore unrealistic speeds
#         self.trajectory_points = []  # List to store detected ball centers
#         self.fps = None  # Frames per second of the video
#         self.speed_file = "BallSpeed.txt"  # Output file for ball speeds

#     def calculate_speed(self, prev_position, current_position, fps):
#         # Calculate the Euclidean distance between two points
#         distance = np.linalg.norm(np.array(current_position) - np.array(prev_position))
        
#         # Convert the distance from pixels to real-world units (meters)
#         real_distance = distance * self.scale_factor
        
#         # Calculate the time elapsed between frames
#         time_elapsed = 1 / fps  # Time per frame (in seconds)
        
#         # Speed in meters per second
#         speed_mps = real_distance / time_elapsed
        
#         # Convert to kilometers per hour
#         speed_kmh = speed_mps * 3.6
#         return speed_mps  # Return speed in meters per second

#     def process_video(self):

#         frame_count = 0
#         prev_position = None  # To store the previous position of the ball
#         with open(self.speed_file, 'w') as f:  # Open file to store speeds
#             while True:
#                 # Load the pre-processed frame
#                 frame_path = f'{self.frame_dir}/processed_frame_{frame_count}.png'
                
#                 # If the frame doesn't exist, break the loop
#                 if not os.path.exists(frame_path):
#                     break

#                 frame = cv2.imread(frame_path)

#                 # Extract the ball center from the trajectory points
#                 if frame_count < len(self.trajectory_points):
#                     current_position = self.trajectory_points[frame_count]
                    
#                     # If we have a previous position, calculate the speed
#                     if prev_position is not None:
#                         speed_mps = self.calculate_speed(prev_position, current_position, self.fps)

#                         # Only record speeds that are below the threshold
#                         if speed_mps < self.speed_threshold:
#                             f.write(f" {speed_mps:.2f}\n")
#                             print(f"Frame {frame_count}: {speed_mps:.2f} m/s")

#                     prev_position = current_position

#                 # Increment frame_count
#                 frame_count += 1

#         print("Speed calculation complete.")

# # Usage
# if __name__ == "__main__":

#     frame_dir = 'Frame_b'  # Assuming the processed frames are in 'Frame_b' after running BallTrackingandMapping script
#     tracker = CricketBallTracker(frame_dir=frame_dir, scale_factor=0.06, speed_threshold=160)
#     tracker.process_video()


import cv2
import os
import numpy as np
from ultralytics import YOLO  # Make sure you have the correct YOLO model installed

class CricketBallTracker:
    def __init__(self, video_path, model_path, frame_dir='Frame', processed_frame_dir='Frame_b', scale_factor=0.05, speed_threshold=100):
        self.video_path = video_path
        self.model = YOLO(model_path)
        self.frame_dir = frame_dir
        self.processed_frame_dir = processed_frame_dir
        self.scale_factor = scale_factor  # Scaling factor to convert pixels to real-world units
        self.speed_threshold = speed_threshold  # Threshold to ignore unrealistic speeds
        self.trajectory_points = []  # List to store detected ball centers
        self.fps = None  # Frames per second of the video
        self.speed_file = "BallSpeed.txt"  # Output file for ball speeds

    def calculate_speed(self, prev_position, current_position, fps):
        # Calculate the Euclidean distance between two points
        distance = np.linalg.norm(np.array(current_position) - np.array(prev_position))
        
        # Convert the distance from pixels to real-world units (meters)
        real_distance = distance * self.scale_factor
        
        # Calculate the time elapsed between frames
        time_elapsed = 1 / fps  # Time per frame (in seconds)
        
        # Speed in meters per second
        speed_mps = real_distance / time_elapsed
        
        # Convert to kilometers per hour
        speed_kmh = speed_mps * 3.6
        return speed_mps  # Return speed in meters per second

    def process_video(self):
        cap = cv2.VideoCapture(self.video_path)
        if not cap.isOpened():
            print("Error opening video stream or file")
            return

        self.fps = cap.get(cv2.CAP_PROP_FPS)  # Get frames per second from the video

        # Clean up the directories where frames will be stored
        self.cleanup_directories([self.frame_dir, self.processed_frame_dir])

        frame_count = 0
        prev_position = None  # To store the previous position of the ball
        with open(self.speed_file, 'w') as f:  # Open file to store speeds
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                frame_path = f'{self.frame_dir}/{frame_count}.png'
                cv2.imwrite(frame_path, frame)

                # Use YOLO model to detect ball in the current frame
                results = self.model(frame)
                detected_balls = []

                # Extract bounding boxes of detected balls
                for result in results:
                    for box in result.boxes.xyxy:
                        x1, y1, x2, y2 = map(int, box[:4])
                        center = ((x1 + x2) // 2, (y1 + y2) // 2)
                        radius = max((x2 - x1) // 2, (y2 - y1) // 2)
                        detected_balls.append((center, radius))

                if detected_balls:
                    # Find the largest ball (most likely the cricket ball)
                    largest_ball = max(detected_balls, key=lambda x: x[1])
                    largest_center, largest_radius = largest_ball
                    
                    # Store the detected ball's center
                    self.trajectory_points.append(largest_center)
                    cv2.circle(frame, largest_center, largest_radius, (0, 255, 0), 2)

                    # If we have a previous position, calculate the speed
                    if prev_position is not None:
                        speed_mps = self.calculate_speed(prev_position, largest_center, self.fps)

                        # Only record speeds that are below the threshold
                        if speed_mps < self.speed_threshold:
                            f.write(f" {speed_mps:.2f}\n")
                            print(f"Frame {frame_count}: {speed_mps:.2f} m/s")

                    prev_position = largest_center

                # Save the processed frame with ball detection
                cv2.imwrite(f'{self.processed_frame_dir}/processed_frame_{frame_count}.png', frame)
                frame_count += 1

        cap.release()
        cv2.destroyAllWindows()

    def cleanup_directories(self, dirs):
        for dir_path in dirs:
            if not os.path.exists(dir_path):
                os.makedirs(dir_path)

# Usage
if __name__ == "__main__":
    model_path = os.path.join('runs', 'detect', 'train3', 'weights', 'best.pt')
    video_path = "videos/NetPractice6.mp4"  # Replace with the path to your video

    tracker = CricketBallTracker(video_path, model_path, scale_factor=0.06, speed_threshold=160)
    tracker.process_video()
