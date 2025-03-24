# import os
# from BallSpeedandDetection import CricketBallTracker

# class FinalVideoProcessing:

#     def __init__(self, video_path, model_path, pitch_image):
#         self.video_path = video_path
#         self.model_path = model_path
#         self.pitch_image_path = pitch_image
#         self.ball_tracker = CricketBallTracker(video_path, model_path, pitch_image)
#         print("\nInitializing ball tracking...")
        
#         # Initialize the ball tracking and homography
#         self.ball_tracker.define_homography()  # Define the homography matrix

#     def process_video(self):
#         # Call process_video from CricketBallTracker to track ball and save trajectory points
#         print("\nProcessing video...")
#         self.ball_tracker.process_video()

#     def map_trajectory(self):
#         # Map the trajectory onto the pitch and save the bounce coordinates
#         print("\nMapping trajectory onto pitch...")
#         self.ball_tracker.map_trajectory_to_pitch()

# if __name__ == "__main__":
#     video_path = 'NetPractice6.mp4'  # Make sure this path is correct and accessible
#     model_path = os.path.join('runs', 'detect', 'train8', 'weights', 'best.pt')  # Correct model path
#     pitch_image_path = 'pitch.jpeg'  # Ensure this image is available in the path

#     # Initialize the FinalVideoProcessing object
#     final_processor = FinalVideoProcessing(video_path, model_path, pitch_image_path)
    
#     # Call process_video() to track the ball and save the trajectory points
#     final_processor.process_video()
    
#     # Optionally, call map_trajectory() to map the trajectory to the pitch after video processing
#     final_processor.map_trajectory()



import os
import cv2
import numpy as np
from BallSpeedandDetection import CricketBallTracker
from BatsmanPosition import BatsmanHandednessDetector

class FinalVideoProcessing:

    def __init__(self, video_path, model_path, pitch_image):
        self.video_path = video_path
        self.model_path = model_path
        self.pitch_image_path = pitch_image
        self.ball_tracker = CricketBallTracker(video_path, model_path, pitch_image)
        print("\nInitializing ball tracking...")

        # Initialize the ball tracking and homography
        self.ball_tracker.define_homography()  # Define the homography matrix

    def process_video(self):
        # Call process_video from CricketBallTracker to track ball and save trajectory points
        print("\nProcessing video...")
        self.ball_tracker.process_video()

    def map_trajectory(self):
        # Map the trajectory onto the pitch and save the bounce coordinates
        print("\nMapping trajectory onto pitch...")
        self.ball_tracker.map_trajectory_to_pitch()

    def smooth_trajectory(self, coordinates):
        smoothed = [coordinates[0]]
        for i in range(1, len(coordinates)):
            if coordinates[i] != coordinates[i-1]:
                smoothed.append(coordinates[i])
        return smoothed

    def detect_bounce_point(self, coordinates):
        smoothed_coords = self.smooth_trajectory(coordinates)
        x_coords = [coord[0] for coord in smoothed_coords]
        y_coords = [coord[1] for coord in smoothed_coords]

        for i in range(1, len(y_coords)-2):
            if y_coords[i] > y_coords[i-1]:
                if y_coords[i+1] > y_coords[i] and y_coords[i+2] < y_coords[i+1]:
                    original_index = coordinates.index(smoothed_coords[i])
                    return coordinates[original_index], original_index
        return coordinates[-1], len(coordinates)-1

    def read_coordinates_from_file(self, filename):
        coordinates = []
        with open(filename, 'r') as f:
            for line in f.readlines():
                x, y = map(float, line.strip().split(','))
                coordinates.append((x, y))
        return coordinates

class BallLine:
    def __init__(self, ball_position, batsman_hand):
        self.ball_position = ball_position
        self.batsman_hand = batsman_hand

    def determine_pitch_line(self):
        if self.batsman_hand not in ["right", "left"]:
            raise ValueError("Invalid batsman hand. Use 'right' or 'left'.")

        middle_stump_coords = [(110, 57), (138, 57), (111, 544), (138, 545)]
        off_stump_coords = [(54, 17), (110, 16), (54, 585), (110, 584)]
        leg_stump_coords = [(139, 16), (191, 16), (139, 585), (193, 585)]

        if self.batsman_hand == "left":
            off_stump_coords, leg_stump_coords = leg_stump_coords, off_stump_coords

        for stump, coords in zip(["middle stump", "off stump", "leg stump"], 
                                 [middle_stump_coords, off_stump_coords, leg_stump_coords]):
            x_coords = [coord[0] for coord in coords]
            y_coords = [coord[1] for coord in coords]
            if min(x_coords) <= self.ball_position[0] <= max(x_coords) and min(y_coords) <= self.ball_position[1] <= max(y_coords):
                return stump
        return "unknown"

class BallLength:
    def __init__(self, ball_position):
        self.ball_position = ball_position

    def determine_pitch_length(self):
        pitch_zones = {
            "yorker": [(54, 57), (192, 57), (54, 95), (192, 90)],
            "full toss": [(54, 96), (192, 95), (54, 131), (192, 130)],
            "good length": [(54, 132), (192, 135), (54, 201), (192, 195)],
            "short pitch": [(54, 210), (192, 200), (54, 300), (192, 300)],
            "bouncer": [(54, 317), (192, 302), (54, 400), (192, 400)]
        }

        for length, coords in pitch_zones.items():
            x_coords = [coord[0] for coord in coords]
            y_coords = [coord[1] for coord in coords]
            if min(x_coords) <= self.ball_position[0] <= max(x_coords) and min(y_coords) <= self.ball_position[1] <= max(y_coords):
                return length
        return "unknown"

if __name__ == "__main__":
    video_path = 'NetPractice6.mp4'  # Make sure this path is correct and accessible
    model_path = os.path.join('runs', 'detect', 'train8', 'weights', 'best.pt')  # Correct model path
    pitch_image_path = 'pitch.jpeg'  # Ensure this image is available in the path

    # Initialize the FinalVideoProcessing object
    final_processor = FinalVideoProcessing(video_path, model_path, pitch_image_path)
    
    # Call process_video() to track the ball and save the trajectory points
    final_processor.process_video()
    
    # Optionally, call map_trajectory() to map the trajectory to the pitch after video processing
    final_processor.map_trajectory()

    # Load image for drawing
    image = cv2.imread(pitch_image_path)
    if image is None:
        raise Exception("Failed to load the image. Check the file path!")

    # Read bounce coordinates from file
    coordinates = final_processor.read_coordinates_from_file('bounce_coords.txt')
    
    # Detect bounce point
    bounce_point, bounce_index = final_processor.detect_bounce_point(coordinates)
    ball_position = bounce_point

    # Detect batsman's handedness using BatsmanHandednessDetector
    detector = BatsmanHandednessDetector(video_path)
    detector.process_video()
    batsman_hand = "right" if detector.final_handedness == "Right-handed" else "left"

    # Create BallLine and BallLength instances
    ball_line = BallLine(ball_position, batsman_hand)
    pitch_line = ball_line.determine_pitch_line()

    ball_length = BallLength(ball_position)
    pitch_length = ball_length.determine_pitch_length()

    # Output the results in the specified format
    print(f"Batsman Position: {batsman_hand.capitalize()}")
    print(f"Ball Line: {pitch_line}")
    print(f"Ball Length: {pitch_length}")

    # Draw the ball position on the pitch image
    cv2.circle(image, (int(ball_position[0]), int(ball_position[1])), 5, (0, 0, 255), -1)
    #cv2.imshow('Pitch with Ball', image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
