import mediapipe as mp
import cv2

class BatsmanHandednessDetector:
    def __init__(self, video_path):
        self.video_path = video_path
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose()
        self.final_handedness = None

    def process_video(self):
        
        cap = cv2.VideoCapture(self.video_path)

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            results = self.pose.process(rgb_frame)

            if results.pose_landmarks:
                # Get keypoints for left and right wrists
                left_wrist = results.pose_landmarks.landmark[self.mp_pose.PoseLandmark.LEFT_WRIST]
                right_wrist = results.pose_landmarks.landmark[self.mp_pose.PoseLandmark.RIGHT_WRIST]

                # Get keypoints for left and right ankles
                left_ankle = results.pose_landmarks.landmark[self.mp_pose.PoseLandmark.LEFT_ANKLE]
                right_ankle = results.pose_landmarks.landmark[self.mp_pose.PoseLandmark.RIGHT_ANKLE]

                # Draw the keypoints on the frame
                frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)
                cv2.circle(frame, (int(left_wrist.x * frame.shape[1]), int(left_wrist.y * frame.shape[0])), 5, (0, 255, 0), -1)
                cv2.circle(frame, (int(right_wrist.x * frame.shape[1]), int(right_wrist.y * frame.shape[0])), 5, (0, 0, 255), -1)
                cv2.circle(frame, (int(left_ankle.x * frame.shape[1]), int(left_ankle.y * frame.shape[0])), 5, (255, 255, 0), -1)
                cv2.circle(frame, (int(right_ankle.x * frame.shape[1]), int(right_ankle.y * frame.shape[0])), 5, (255, 0, 255), -1)

                final_handedness = self.determine_handedness(left_ankle, right_ankle, left_wrist, right_wrist)

                self.final_handedness = final_handedness

                cv2.putText(frame, f"Batsman: {final_handedness}", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

            cv2.imshow('Batsman Handedness', frame)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

        if self.final_handedness:
            print(f"Batsman Handedness: {self.final_handedness} batsman")

        cap.release()
        cv2.destroyAllWindows()

    def determine_handedness(self, left_ankle, right_ankle, left_wrist, right_wrist):
        """Determine handedness based on ankle and wrist positions."""
        if left_ankle.x > right_ankle.x:  
            return "Right-handed"
        elif right_ankle.x > left_ankle.x:  
            return "Left-handed"
        else:
            if left_wrist.x > right_wrist.x:
                return "Right-handed"
            else:
                return "Left-handed"

if __name__ == "__main__":
    video_path = "Video.mp4"
    detector = BatsmanHandednessDetector(video_path)
    detector.process_video()

