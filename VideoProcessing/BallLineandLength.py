# import cv2
# import numpy as np

# image = cv2.imread('pitch.jpeg')

# if image is None:
#     raise Exception("Failed to load the image. Check the file path!")

# def smooth_trajectory(coordinates):
#     # Remove consecutive duplicates to reduce noise
#     smoothed = [coordinates[0]]
#     for i in range(1, len(coordinates)):
#         if coordinates[i] != coordinates[i-1]:
#             smoothed.append(coordinates[i])
#     return smoothed

# def detect_bounce_point(coordinates):
#     # Smooth the trajectory to handle noise
#     smoothed_coords = smooth_trajectory(coordinates)
    
#     x_coords = [coord[0] for coord in smoothed_coords]
#     y_coords = [coord[1] for coord in smoothed_coords]
    
#     # Look for a pattern: rise -> peak -> fall
#     for i in range(1, len(y_coords)-2):
#         # Check if y is increasing (approaching bounce)
#         if y_coords[i] > y_coords[i-1]:
#             # Check for a rise after this point (post-bounce upward motion)
#             if y_coords[i+1] > y_coords[i]:
#                 # Check for a fall after the rise (post-bounce downward motion)
#                 if y_coords[i+2] < y_coords[i+1]:
#                     # Map the smoothed index back to the original coordinates
#                     original_index = coordinates.index(smoothed_coords[i])
#                     return coordinates[original_index], original_index
    
#     # Fallback: return the last point if no bounce is detected
#     return coordinates[-1], len(coordinates)-1


# def read_coordinates_from_file(filename):
#     coordinates = []
#     with open(filename, 'r') as f:
#         for line in f.readlines():
#             # Each line is expected to be in the format "x,y\n"
#             x, y = map(float, line.strip().split(','))
#             coordinates.append((x, y))
#     return coordinates


# coordinates = read_coordinates_from_file('bounce_coords.txt')

# bounce_point, bounce_index = detect_bounce_point(coordinates)

# # Save the bounce point to 'ball_position'
# ball_position =  bounce_point


# print("Trajectory points from 'bounce_coords.txt':")
# for i, coord in enumerate(coordinates):
#     print(f"Point {i}: {coord}")

# print(f"\nDetected bounce point: {bounce_point} at index {bounce_index}")
# print(f"Ball position (detected bounce point): {ball_position}")


# cv2.circle(image, (int(ball_position[0]), int(ball_position[1])), 5, (0, 0, 255), -1)
# ###################################################################################################################
#                                     #Pitch Line#
# ###################################################################################################################

# middle_stump_coords = [(110, 57), (138, 57), (111, 544), (138, 545)]

# x_coords = [coord[0] for coord in middle_stump_coords]
# y_coords = [coord[1] for coord in middle_stump_coords]

# if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
#     pitch_line = "middle stump"

# off_stump_coords = [(54, 17), (110, 16), (54, 585), (110, 584)]

# x_coords = [coord[0] for coord in off_stump_coords]
# y_coords = [coord[1] for coord in off_stump_coords]

# if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
#     pitch_line = "off stump"

# leg_stump_coords = [(139, 16), (191, 16), (139, 585), (193, 585)]
    
# x_coords = [coord[0] for coord in leg_stump_coords]
# y_coords = [coord[1] for coord in leg_stump_coords]

# if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
#     pitch_line = "leg stump"


# ###################################################################################################################
#                                     #Pitch Length#
# ###################################################################################################################


# yorker_coords = [(54, 57), (192, 57), (54, 95), (192, 90)]


# x_coords = [coord[0] for coord in yorker_coords]
# y_coords = [coord[1] for coord in yorker_coords]

# if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
#     pitch_length = "yorker"
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


# full_toss_coords = [(54, 96), (192, 95), (54, 131), (192, 130)]


# x_coords_ft = [coord[0] for coord in full_toss_coords]
# y_coords_ft = [coord[1] for coord in full_toss_coords]

# if min(x_coords_ft) <= ball_position[0] <= max(x_coords_ft) and min(y_coords_ft) <= ball_position[1] <= max(y_coords_ft):
#     pitch_length = "full toss"
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


# good_length_coords = [(54, 132), (192, 135), (54, 201), (192, 195)]

# x_coords_gl = [coord[0] for coord in good_length_coords]
# y_coords_gl = [coord[1] for coord in good_length_coords]

# if min(x_coords_gl) <= ball_position[0] <= max(x_coords_gl) and min(y_coords_gl) <= ball_position[1] <= max(y_coords_gl):
#     pitch_length = "good length"
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


# short_pitch_coords = [(54, 210), (192, 200), (54, 300), (192, 300)]

# x_coords_sp = [coord[0] for coord in short_pitch_coords]
# y_coords_sp = [coord[1] for coord in short_pitch_coords]

# if min(x_coords_sp) <= ball_position[0] <= max(x_coords_sp) and min(y_coords_sp) <= ball_position[1] <= max(y_coords_sp):
#     pitch_length = "short pitch"
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


# bouncer_coords = [(54, 317), (192, 302), (54, 400), (192, 400)]

# x_coords_b = [coord[0] for coord in bouncer_coords]
# y_coords_b = [coord[1] for coord in bouncer_coords]

# if min(x_coords_b) <= ball_position[0] <= max(x_coords_b) and min(y_coords_b) <= ball_position[1] <= max(y_coords_b):
#     pitch_length = "bouncer"
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


# #cv2.imshow('Pitch with Ball', image)
# cv2.waitKey(0)
# cv2.destroyAllWindows()


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

# if __name__ == "__main__":
#     image = cv2.imread('pitch.jpeg')
#     if image is None:
#         raise Exception("Failed to load the image. Check the file path!")

#     coordinates = read_coordinates_from_file('bounce_coords.txt')
#     bounce_point, bounce_index = detect_bounce_point(coordinates)
#     ball_position = bounce_point

#     # Use BatsmanHandednessDetector to detect handedness
#     video_path = "NetPractice6.mp4"
#     detector = BatsmanHandednessDetector(video_path)
#     detector.process_video()
#     batsman_hand = "right" if detector.final_handedness == "Right-handed" else "left"

#     # Using the BallLine and BallLength classes
#     ball_line = BallLine(ball_position, batsman_hand)
#     pitch_line = ball_line.determine_pitch_line()

#     ball_length = BallLength(ball_position)
#     pitch_length = ball_length.determine_pitch_length()

#     print("Trajectory points from 'bounce_coords.txt':")
#     for i, coord in enumerate(coordinates):
#         print(f"Point {i}: {coord}")

#     print(f"\nDetected bounce point: {bounce_point} at index {bounce_index}")
#     print(f"Ball position (detected bounce point): {ball_position}")
#     print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")

#     cv2.circle(image, (int(ball_position[0]), int(ball_position[1])), 5, (0, 0, 255), -1)
#     cv2.waitKey(0)
#     cv2.destroyAllWindows()
