import cv2
import os
import numpy as np
from ultralytics import YOLO

class BallSpeed:
    def __init__(self, video_path, model_path, frame_dir='Frame', processed_frame_dir='Frame_b', 
                 scale_factor=0.05, speed_threshold=2.0, max_speed=45.0):
        """
        Args:
            video_path (str): Path to input video
            model_path (str): Path to YOLO model weights
            frame_dir (str): Directory to store raw frames
            processed_frame_dir (str): Directory to store processed frames
            scale_factor (float): Conversion factor from pixels to meters
            speed_threshold (float): Minimum speed to record (ignore small movements)
            max_speed (float): Maximum allowed speed in m/s (cricket ball physics limit)
        """
        self.video_path = video_path
        self.model = YOLO(model_path)
        self.frame_dir = frame_dir
        self.processed_frame_dir = processed_frame_dir
        self.scale_factor = scale_factor
        self.speed_threshold = speed_threshold  # Ignore speeds below this (e.g., noise)
        self.max_speed = max_speed              # Physics-based upper limit (45 m/s = 162 km/h)
        self.trajectory_points = []
        self.fps = None
        self.speed_file = "BallSpeed.txt"
        
        # Create directories if they don't exist
        os.makedirs(self.frame_dir, exist_ok=True)
        os.makedirs(self.processed_frame_dir, exist_ok=True)

    def calculate_speed(self, prev_position, current_position):
        """Calculate speed between two consecutive frames.
        
        Args:
            prev_position (tuple): (x1, y1) coordinates of previous detection
            current_position (tuple): (x2, y2) coordinates of current detection
            
        Returns:
            float: Speed in meters/second
        """
        distance_pixels = np.linalg.norm(np.array(current_position) - np.array(prev_position))
        distance_meters = distance_pixels * self.scale_factor
        time_seconds = 1 / self.fps
        return distance_meters / time_seconds

    def process_video_for_speed(self):
        """Main method to process video and calculate ball speeds."""
        cap = cv2.VideoCapture(self.video_path)
        if not cap.isOpened():
            raise IOError(f"Cannot open video file: {self.video_path}")

        self.fps = cap.get(cv2.CAP_PROP_FPS)
        print(f"Video FPS: {self.fps:.2f}")
        
        frame_count = 0
        prev_position = None
        
        with open(self.speed_file, 'w') as speed_log:
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                # Save raw frame
                cv2.imwrite(f'{self.frame_dir}/{frame_count:04d}.png', frame)

                # Detect ball using YOLO
                results = self.model(frame)
                current_position = None
                
                for result in results:
                    for box in result.boxes.xyxy:
                        x1, y1, x2, y2 = map(int, box[:4])
                        center = ((x1 + x2) // 2, (y1 + y2) // 2)
                        current_position = center
                        
                        # Draw detection on frame
                        cv2.circle(frame, center, 5, (0, 255, 0), -1)
                        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

                if current_position:
                    self.trajectory_points.append(current_position)
                    
                    if prev_position is not None:
                        speed_mps = self.calculate_speed(prev_position, current_position)
                        
                        # Apply physics-based validation
                        if self.speed_threshold < speed_mps < self.max_speed:
                            speed_log.write(f"{speed_mps:.2f}\n")
                            print(f"Frame {frame_count:04d}: Speed = {speed_mps:.2f} m/s ({speed_mps*3.6:.2f} km/h)")
                        else:
                            print(f"Frame {frame_count:04d}: IGNORED - Speed {speed_mps:.2f} m/s (outside valid range)")

                    prev_position = current_position

                # Save processed frame
                cv2.imwrite(f'{self.processed_frame_dir}/processed_{frame_count:04d}.png', frame)
                frame_count += 1

        cap.release()
        cv2.destroyAllWindows()
        print(f"\nProcessing complete. Valid speeds saved to {self.speed_file}")