from BatsmanPosition import BatsmanHandednessDetector
from BallSpeedandDetection import BallTracking


class FinalVideoProcessing:
    def __init__(self, video_path):
        self.video_path = video_path
        self.batsman_detector = BatsmanHandednessDetector(video_path)
        self.ball_tracker = BallTracking(video_path)

    def process_video(self):
        print("Processing batsman handedness...")
        self.batsman_detector.process_video()

        print("\nProcessing ball tracking...")
        self.ball_tracker.process_video()
        self.ball_tracker.calculate_speeds()
        self.ball_tracker.create_output_video(output_filename='output_video.mp4')

        # Display final outputs
        if self.batsman_detector.final_handedness:
            print(f"\nBatsman Position: {self.batsman_detector.final_handedness} batsman")
        print("\nProcessing complete.")

if __name__ == "__main__":
    video_path = 'Video.mp4'
    final_processor = FinalVideoProcessing(video_path)
    final_processor.process_video()