import cv2
import numpy as np
from BatsmanPosition import BatsmanHandednessDetector

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

def smooth_trajectory(coordinates):
    smoothed = [coordinates[0]]
    for i in range(1, len(coordinates)):
        if coordinates[i] != coordinates[i-1]:
            smoothed.append(coordinates[i])
    return smoothed

def detect_bounce_point(coordinates):
    smoothed_coords = smooth_trajectory(coordinates)
    x_coords = [coord[0] for coord in smoothed_coords]
    y_coords = [coord[1] for coord in smoothed_coords]
    
    for i in range(1, len(y_coords)-2):
        if y_coords[i] > y_coords[i-1]:
            if y_coords[i+1] > y_coords[i] and y_coords[i+2] < y_coords[i+1]:
                original_index = coordinates.index(smoothed_coords[i])
                return coordinates[original_index], original_index
    return coordinates[-1], len(coordinates)-1

def read_coordinates_from_file(filename):
    coordinates = []
    with open(filename, 'r') as f:
        for line in f.readlines():
            x, y = map(float, line.strip().split(','))
            coordinates.append((x, y))
    return coordinates

if __name__ == "__main__":
    image = cv2.imread('pitch.jpeg')
    if image is None:
        raise Exception("Failed to load the image. Check the file path!")

    coordinates = read_coordinates_from_file('bounce_coords.txt')
    bounce_point, bounce_index = detect_bounce_point(coordinates)
    ball_position = bounce_point

    # Use BatsmanHandednessDetector to detect handedness
    video_path = "NetPractice6.mp4"
    detector = BatsmanHandednessDetector(video_path)
    detector.process_video()
    batsman_hand = "right" if detector.final_handedness == "Right-handed" else "left"

    # Using the BallLine and BallLength classes
    ball_line = BallLine(ball_position, batsman_hand)
    pitch_line = ball_line.determine_pitch_line()

    ball_length = BallLength(ball_position)
    pitch_length = ball_length.determine_pitch_length()

    print("Trajectory points from 'bounce_coords.txt':")
    for i, coord in enumerate(coordinates):
        print(f"Point {i}: {coord}")

    print(f"\nDetected bounce point: {bounce_point} at index {bounce_index}")
    print(f"Ball position (detected bounce point): {ball_position}")
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")

    cv2.circle(image, (int(ball_position[0]), int(ball_position[1])), 5, (0, 0, 255), -1)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
