import cv2
import numpy as np
import os
from inference_sdk import InferenceHTTPClient


class BatsmanPosition:
    def __init__(self, frame_dir='Frame', pitch_image_path='pitch.jpeg'):
        self.frame_dir = frame_dir
        self.pitch_image_path = pitch_image_path
        self.batsman_coords = None  # Initialize variable to store batsman coordinates
        self.batsman_hand = None  # Attribute to store batsman's hand (left or right)

        self.CLIENT = InferenceHTTPClient(
            api_url="https://detect.roboflow.com",
            api_key="KpDwP2FpF9DQAmko7ltC"
        )

    def mark_batsman_position(self):
        """Detects and marks the batsman position in the first frame."""
        image_path = os.path.join(self.frame_dir, "0.png")
        
        # Run inference to detect batsman
        result = self.CLIENT.infer(image_path, model_id="batsman-detection-2kajl/3")

        # Load the image with OpenCV
        image = cv2.imread(image_path)

        # Check if image is loaded successfully
        if image is None:
            print("Failed to load image!")
            return
        else:
            print("Image loaded successfully.")

        # Open a file to store batsman position
        for detection in result['predictions']:
            # Get the coordinates and size of the bounding box
            x_min = int(detection['x'] - detection['width'] / 2)
            y_min = int(detection['y'] - detection['height'] / 2)
            x_max = int(detection['x'] + detection['width'] / 2)
            y_max = int(detection['y'] + detection['height'] / 2)

            # Calculate the middle coordinate at the bottom edge
            middle_x = (x_min + x_max) // 2
            middle_y = y_max

            # Save the coordinates for future use
            self.batsman_coords = (middle_x, middle_y)
            print(f"Detected Batsman Position: ({middle_x}, {middle_y})")

            # Draw the bounding box on the image
            cv2.rectangle(image, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)
            
            # Draw the middle coordinate point
            cv2.circle(image, (middle_x, middle_y), 5, (255, 0, 0), -1)  # Blue dot

        # Display the image with bounding box and middle position
        #cv2.imshow('Batsman Detection', image)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

        # Save the position in the BatsmanPosition.txt file
        if self.batsman_coords:
            with open("BatsmanPosition.txt", "w") as file:
                file.write(f"{self.batsman_coords[0]}, {self.batsman_coords[1]}\n")

    def map_batsman_to_pitch(self, batsman_coords, pitch_image_path, homography_matrix_path='homography_matrix.npy'):
        """Maps batsman coordinates to the pitch using homography and saves it."""
        
        # Load the pitch image
        pitch = cv2.imread(pitch_image_path)

        # Load the homography matrix
        H = np.load(homography_matrix_path)

        # Get batsman coordinates (x, y)
        batsman_x, batsman_y = batsman_coords

        # Convert to the format required for perspective transformation
        batsman_point = np.array([[[batsman_x, batsman_y]]], dtype='float32')

        # Apply perspective transform
        mapped_point = cv2.perspectiveTransform(batsman_point, H)

        # Get the mapped X, Y coordinates
        mapped_x, mapped_y = mapped_point[0][0]

        # Ensure the coordinates are within the bounds of the pitch image
        pitch_height, pitch_width = pitch.shape[:2]
        mapped_x = np.clip(mapped_x, 0, pitch_width - 1)
        mapped_y = np.clip(mapped_y, 0, pitch_height - 1)

        # Mark the batsman's position on the pitch
        cv2.circle(pitch, (int(mapped_x), int(mapped_y)), 2, (0, 0, 255), -1)  # Red dot

        # Save or display the result
        cv2.imwrite('mapped_batsman_position_on_pitch.png', pitch)
        #cv2.imshow('Mapped Batsman Position', pitch)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

        # Print the mapped coordinates
        print(f"Batsman Position (Mapped to Pitch): ({int(mapped_x)}, {int(mapped_y)})")

        # Check batsman's hand based on position
        self.check_batsman_hand(mapped_x, mapped_y)

        # Save the mapped coordinates to BatsmanPosition.txt
        with open("BatsmanPosition.txt", "w") as file:
            file.write(f"{int(mapped_x)}, {int(mapped_y)}\n")

    def check_batsman_hand(self, batsman_x, batsman_y):
        """Check if the batsman is on the left or right side of the pitch."""
        # Coordinates for the pitch boundary
        left_side = [(125, 17), (122, 583), (53, 584), (54, 17)]  # Left side (from middle stump)
        right_side = [(125, 17), (192, 15), (192, 585), (125, 583)]  # Right side (from middle stump)

        # Simplified check: If the batsman is on the right side or left side based on x-coordinate
        if batsman_x > 125:  # Batsman is on the right side
            self.batsman_hand = 'right'
            print("Batsman Position: right")
        else:  # Batsman is on the left side
            self.batsman_hand = 'left'
            print("Batsman Position: left")
