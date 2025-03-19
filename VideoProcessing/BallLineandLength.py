import cv2
import numpy as np

# Load the image
image = cv2.imread('pitch.jpeg')

if image is None:
    raise Exception("Failed to load the image. Check the file path!")


try:
    with open('bounce_coords.txt', 'r') as f:
        bounce_coords = f.readline().strip()
        ball_position = tuple(map(int, bounce_coords.split(',')))
        print(f"Loaded bounce point: {ball_position}")
except FileNotFoundError:
    raise Exception("Bounce coordinates file not found!")

#Mark the ball with the red color which is the bounce position.
cv2.circle(image, ball_position, 5, (0, 0, 255), -1)

###################################################################################################################
                                    #Pitch Line#
###################################################################################################################

middle_stump_coords = [(110, 57), (138, 57), (111, 544), (138, 545)]

x_coords = [coord[0] for coord in middle_stump_coords]
y_coords = [coord[1] for coord in middle_stump_coords]

if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
    pitch_line = "middle stump"

off_stump_coords = [(54, 17), (110, 16), (54, 585), (110, 584)]

x_coords = [coord[0] for coord in off_stump_coords]
y_coords = [coord[1] for coord in off_stump_coords]

if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
    pitch_line = "off stump"

leg_stump_coords = [(139, 16), (191, 16), (139, 585), (193, 585)]
    
x_coords = [coord[0] for coord in leg_stump_coords]
y_coords = [coord[1] for coord in leg_stump_coords]

if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
    pitch_line = "leg stump"


###################################################################################################################
                                    #Pitch Length#
###################################################################################################################


yorker_coords = [(54, 57), (192, 57), (54, 95), (192, 90)]


x_coords = [coord[0] for coord in yorker_coords]
y_coords = [coord[1] for coord in yorker_coords]

if min(x_coords) <= ball_position[0] <= max(x_coords) and min(y_coords) <= ball_position[1] <= max(y_coords):
    pitch_length = "yorker"
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


full_toss_coords = [(54, 96), (192, 95), (54, 131), (192, 130)]


x_coords_ft = [coord[0] for coord in full_toss_coords]
y_coords_ft = [coord[1] for coord in full_toss_coords]

if min(x_coords_ft) <= ball_position[0] <= max(x_coords_ft) and min(y_coords_ft) <= ball_position[1] <= max(y_coords_ft):
    pitch_length = "full toss"
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


good_length_coords = [(54, 132), (192, 135), (54, 201), (192, 195)]

x_coords_gl = [coord[0] for coord in good_length_coords]
y_coords_gl = [coord[1] for coord in good_length_coords]

if min(x_coords_gl) <= ball_position[0] <= max(x_coords_gl) and min(y_coords_gl) <= ball_position[1] <= max(y_coords_gl):
    pitch_length = "good length"
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


short_pitch_coords = [(54, 210), (192, 200), (54, 300), (192, 300)]

x_coords_sp = [coord[0] for coord in short_pitch_coords]
y_coords_sp = [coord[1] for coord in short_pitch_coords]

if min(x_coords_sp) <= ball_position[0] <= max(x_coords_sp) and min(y_coords_sp) <= ball_position[1] <= max(y_coords_sp):
    pitch_length = "short pitch"
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


bouncer_coords = [(54, 317), (192, 302), (54, 400), (192, 400)]

x_coords_b = [coord[0] for coord in bouncer_coords]
y_coords_b = [coord[1] for coord in bouncer_coords]

if min(x_coords_b) <= ball_position[0] <= max(x_coords_b) and min(y_coords_b) <= ball_position[1] <= max(y_coords_b):
    pitch_length = "bouncer"
    print(f"Pitch line: {pitch_line}\nPitch length: {pitch_length}")


cv2.imshow('Pitch with Ball', image)
cv2.waitKey(0)
cv2.destroyAllWindows()
