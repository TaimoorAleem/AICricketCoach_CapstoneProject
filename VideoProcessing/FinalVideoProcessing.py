import os
import cv2
import numpy as np
from BallDetectionandMapping import CricketBallTracker
from BatsmanPosition import BatsmanPosition
from BallSpeed import BallSpeed


class FinalVideoProcessing:
    def __init__(self, video_path, model_path, pitch_model_path, pitch_image):
        self.video_path = video_path
        self.model_path = model_path
        self.pitch_model_path = pitch_model_path
        self.pitch_image_path = pitch_image
        self.ball_tracker = CricketBallTracker(video_path, model_path, pitch_model_path, pitch_image)
        self.speed_tracker = BallSpeed(video_path, model_path, scale_factor=0.15, speed_threshold=2.0, max_speed=45.0)
        self.batsman_position = BatsmanPosition()
        print("\nInitializing ball tracking...")

    def process_video(self):
        print("\nProcessing video...")
        self.ball_tracker.process_video()
        print("\nCalculating ball speed...")
        self.speed_tracker.process_video_for_speed()
        print("Ball speed data saved to BallSpeed.txt")

    def map_trajectory(self):
        print("\nMapping trajectory onto pitch...")
        self.ball_tracker.map_trajectory_to_pitch()

    def smooth_trajectory(self, coordinates):
        return [coordinates[i] for i in range(len(coordinates)) if i == 0 or coordinates[i] != coordinates[i - 1]]

    def detect_bounce_point(self, coordinates):
        smoothed_coords = self.smooth_trajectory(coordinates)
        for i in range(1, len(smoothed_coords) - 2):
            if smoothed_coords[i][1] > smoothed_coords[i - 1][1] and smoothed_coords[i + 1][1] > smoothed_coords[i][1] and smoothed_coords[i + 2][1] < smoothed_coords[i + 1][1]:
                return smoothed_coords[i], i
        return smoothed_coords[-1], len(smoothed_coords) - 1

    def read_coordinates_from_file(self, filename):
        try:
            with open(filename, 'r') as f:
                return [tuple(map(float, line.strip().split(','))) for line in f.readlines()]
        except FileNotFoundError:
            print(f"Error: {filename} not found.")
            return []

    def detect_batsman(self):
        print("\nDetecting batsman position...")
        self.batsman_position.mark_batsman_position()
        return self.batsman_position.batsman_hand  # Return the handedness directly

class BallLine:
    def __init__(self, ball_position, batsman_hand):
        self.ball_position = ball_position
        self.batsman_hand = batsman_hand

    def determine_pitch_line(self):
        if self.batsman_hand not in ["right", "left"]:
            return "unknown"

        stump_coords = {
            "middle stump": [(110, 57), (138, 57), (111, 544), (138, 545)],
            "off stump": [(54, 17), (110, 16), (54, 585), (110, 584)],
            "leg stump": [(139, 16), (191, 16), (139, 585), (193, 585)]
        }
        
        if self.batsman_hand == "left":
            stump_coords["off stump"], stump_coords["leg stump"] = stump_coords["leg stump"], stump_coords["off stump"]

        for stump, coords in stump_coords.items():
            if any(min(c[0] for c in coords) <= self.ball_position[0] <= max(c[0] for c in coords) and min(c[1] for c in coords) <= self.ball_position[1] <= max(c[1] for c in coords) for c in coords):
                return stump
        return "unknown"

class BallLength:
    def __init__(self, ball_position):
        self.ball_position = ball_position

    def determine_pitch_length(self):
        pitch_zones = {
            "yorker": [(54, 57), (192, 57), (54, 95), (192, 90)],
            "full-pitched": [(54, 96), (192, 95), (54, 132), (192, 130)],
            "good length": [(54, 132), (192, 135), (54, 201), (192, 195)],
            "short pitch": [(54, 210), (192, 200), (54, 300), (192, 300)],
            "bouncer": [(54, 317), (192, 302), (54, 400), (192, 400)]
        }
        
        for length, coords in pitch_zones.items():
            if any(min(c[0] for c in coords) <= self.ball_position[0] <= max(c[0] for c in coords) and min(c[1] for c in coords) <= self.ball_position[1] <= max(c[1] for c in coords) for c in coords):
                return length
        return "unknown"

def read_speeds_from_file(filename):
    try:
        with open(filename, 'r') as file:
            return [float(line.strip()) for line in file if line.strip().replace('.', '', 1).isdigit()]
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        return []

def moving_average(data, window_size):
    return [np.mean(data[max(0, i - window_size // 2):min(len(data), i + window_size // 2 + 1)]) for i in range(len(data))]

if __name__ == "__main__":
    video_path = "videos/NetPractice8.mp4"
    model_path = os.path.join('runs', 'detect', 'train3', 'weights', 'best.pt')
    pitch_model_path = os.path.join('runs', 'pitch_detection', 'best.pt')
    pitch_image_path = 'pitch.jpeg'
    
    # Initialize the video processor
    final_processor = FinalVideoProcessing(video_path, model_path, pitch_model_path, pitch_image_path)
    
    # Process the video to detect ball and calculate speed
    final_processor.process_video()
    
    # Map the trajectory to the pitch image
    final_processor.map_trajectory()
    
    # Load the pitch image
    image = cv2.imread(pitch_image_path)
    if image is None:
        raise Exception("Failed to load the image. Check the file path!")
    
    # Read and process ball coordinates
    coordinates = final_processor.read_coordinates_from_file('bounce_coords.txt')
    if not coordinates:
        raise Exception("No ball coordinates found in bounce_coords.txt")
    
    # Detect bounce point
    bounce_point, _ = final_processor.detect_bounce_point(coordinates)
    
    # Detect batsman and get handedness (now properly returned)
    batsman_hand = final_processor.detect_batsman()
    if batsman_hand is None:
        print("Warning: Could not determine batsman handedness")
        batsman_hand = "unknown"  # Default value
    
    # Determine pitch line and length
    ball_line = BallLine(bounce_point, batsman_hand)
    pitch_line = ball_line.determine_pitch_line()
    
    ball_length = BallLength(bounce_point)
    pitch_length = ball_length.determine_pitch_length()
    
    # Print all results
    print("\nCricket Ball Analysis Results:")
    print("----------------------------")
    print(f"Batsman Position: {batsman_hand}")
    print(f"Ball Line: {pitch_line}")
    print(f"Ball Length: {pitch_length}")
    
    # Calculate and print ball speed
    ball_speeds_mps = read_speeds_from_file('BallSpeed.txt')
    if ball_speeds_mps:
        ball_speeds_kmh = [speed * 3.6 for speed in ball_speeds_mps]
        avg_speed = np.mean(ball_speeds_kmh)
        print(f"Ball Speed: {avg_speed:.2f} km/h")
    else:
        print("Warning: No ball speed data found")
    
    # Visualize the bounce point on the pitch image
    cv2.circle(image, (int(bounce_point[0]), int(bounce_point[1])), 5, (0, 0, 255), -1)
