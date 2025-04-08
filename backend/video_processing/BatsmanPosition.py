import os
import cv2
import mediapipe as mp
from inference_sdk import InferenceHTTPClient  

class BatsmanPosition:
    def __init__(self, frame_dir='Frame'):
        roboflow_creds= os.getenv('ROBOFLOW_CREDENTIALS')
        self.frame_dir = frame_dir
        self.batsman_coords = None  # Store batsman bounding box
        self.batsman_hand = None  # Store batsman's handedness
        # Initialize the model client
        self.CLIENT = InferenceHTTPClient(
            api_url="https://detect.roboflow.com/",
            api_key=roboflow_creds
        )

    def mark_batsman_position(self):
        """Detects and marks the batsman position in the first frame, then determines handedness."""
        image_path = os.path.join(self.frame_dir, "0.png")
        
        
        result = self.CLIENT.infer(image_path, model_id="batsman-detection-2kajl/3")

        # Load the image with OpenCV
        image = cv2.imread(image_path)

        # Check if image is loaded successfully
        if image is None:
            print("Failed to load image!")
            return
        else:
            print("Image loaded successfully.")

        for detection in result['predictions']:
            # Get the bounding box coordinates
            x_min = int(detection['x'] - detection['width'] / 2)
            y_min = int(detection['y'] - detection['height'] / 2)
            x_max = int(detection['x'] + detection['width'] / 2)
            y_max = int(detection['y'] + detection['height'] / 2)

            # Save bounding box coordinates
            self.batsman_coords = (x_min, y_min, x_max, y_max)
            print(f"Detected Batsman Bounding Box: {self.batsman_coords}")

            # Crop the batsman region
            batsman_image = image[y_min:y_max, x_min:x_max]

            # Determine handedness using MediaPipe Pose
            handedness = self.detect_handedness(batsman_image)
            print(f"Batsman Handedness: {handedness}")
            self.batsman_hand = handedness

            # Draw the bounding box on the original image
            cv2.rectangle(image, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)
            cv2.putText(image, handedness, (x_min, y_min - 10), cv2.FONT_HERSHEY_SIMPLEX, 
                        1, (0, 255, 0), 2)

    def detect_handedness(self, batsman_image):
        """Uses MediaPipe Pose to determine if the batsman is right-handed or left-handed."""
        mp_pose = mp.solutions.pose
        pose = mp_pose.Pose(static_image_mode=True)

        # Convert image to RGB for MediaPipe
        image_rgb = cv2.cvtColor(batsman_image, cv2.COLOR_BGR2RGB)

        # Process Image
        results = pose.process(image_rgb)

        if results.pose_landmarks:
            # Get wrist positions
            left_wrist = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_WRIST]
            right_wrist = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_WRIST]

            # Determine handedness
            if left_wrist.x < right_wrist.x:  # Left wrist closer to bowler
                return "left"
            else:
                return "right"
        else:
            return "Handedness Not Detected"


