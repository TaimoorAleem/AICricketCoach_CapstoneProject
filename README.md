# 🎯 Final Year Project - Cricket Video Analysis

## 📹 Video Processing Subsystem

The **Video Processing Subsystem** leverages computer vision and AI models to extract four key gameplay parameters from cricket match videos:

1. **Ball Speed**
2. **Ball Line**
3. **Ball Length**
4. **Batsman Position**

These insights are extracted using trained YOLO models, MediaPipe, and supporting Python scripts that process match footage frame by frame.

---

## 🔍 Ball Characteristics Documentation

---

### 🏏 1. Ball Detection and Pitch Mapping

**Objective**: Detect the cricket ball in each frame and map its trajectory onto a reference pitch image.

**Script**: `BallDetectionandMapping.py`

**Methodology**:

- Uses a YOLO model trained for cricket ball detection.
- Detects the pitch in the first frame using a second YOLO model.
- Extracts four corner coordinates (top-left, top-right, bottom-left, bottom-right) from the detected pitch.
- These coordinates are used as source points for computing a homography matrix.
- The destination points are predefined dummy pitch coordinates based on a top-down pitch image.
- The homography matrix is used to transform trajectory points from camera perspective to the top-down view.
- Detected ball centers across frames are saved as a trajectory and transformed to the pitch view.

**Output**: Mapped trajectory image (mapped_trajectory_on_pitch.png) and bounce coordinates (bounce_coords.txt).

**Example** 

![Detected_pitch.png](VideoProcessing%2FExample_Images%2FDetected_pitch.png)

---

### 🏏 2. Ball Speed

**Objective**: Calculate the speed of the cricket ball in real time from frame-to-frame motion.

**Script**: `BallSpeed.py`

**Methodology**:

- Uses a YOLO model to detect the ball in every frame.
- Calculates displacement between ball positions in consecutive frames.
- Converts pixel distance to meters using a scale factor.
- Calculates speed using the formula:
  ```
  Speed (m/s) = Distance (m) / Time (s)
  ```

**Key Parameters**:

- `scale_factor`: Converts pixels to meters (e.g., 0.15).
- `fps`: Frames per second from the video.
- Speeds below a threshold or above a physical maximum (e.g., 45 m/s) are ignored.

**Output**: A list of valid ball speeds saved to `BallSpeed.txt`.

---

### 📈 3. Ball Line

**Objective**: Determine if the ball would hit the **off stump**, **middle stump**, or **leg stump** based on the batsman’s handedness.

**Class**: `BallLine`

**Methodology**:

- Takes the bounce point and batsman’s handedness.
- Defines bounding boxes around stump areas.
- Compares bounce point to predefined stump coordinates.
- Adjusts coordinate logic based on left- or right-handed batsman.

**Output**: Returns one of `{"off stump", "middle stump", "leg stump", "unknown"}`.

---

### 📏 4. Ball Length

**Objective**: Classify the bounce location into common cricket bowling zones.

**Class**: `BallLength`

**Pitch Zones**:

- **Yorker**
- **Full-pitched**
- **Good length**
- **Short pitch**
- **Bouncer**

**Methodology**:

- Defines hard-coded pitch zones with (x, y) coordinates.
- Compares the bounce point against these zones.

**Output**: Returns zone name or `"unknown"`.

---

### 🫍️ 5. Batsman Position

**Objective**: Detect the batsman’s position and determine if they are **right-handed** or **left-handed**.

**Script**: `BatsmanPosition.py`

**Technologies Used**:

- **Roboflow Model** for batsman bounding box detection.
- **MediaPipe Pose Estimation** for determining wrist positions.

**Methodology**:

1. First frame (`0.png`) is processed using Roboflow to detect the batsman.
2. Batsman region is cropped and passed to MediaPipe.
3. Compares the x-coordinate of left and right wrists to determine which hand is forward.

**Output**: `"right"`, `"left"`, or `"Handedness Not Detected"`.

---

## 🧠 Models Used

- **YOLOv8** for:
  - Ball detection
  - Pitch detection
- **Roboflow API** for:
  - Batsman detection
- **MediaPipe Pose** for:
  - Determining handedness

---

## 🔗 Script Structure

| File Name                    | Purpose                                       |
| ---------------------------- | --------------------------------------------- |
| `FinalVideoProcessing.py`    | Main integration script to call all modules   |
| `BallDetectionandMapping.py` | Detects ball and maps its trajectory to pitch |
| `BallSpeed.py`               | Estimates speed from trajectory               |
| `BatsmanPosition.py`         | Detects batsman and handedness                |

---

## ▶️ How to Run

```bash
python FinalVideoProcessing.py
```

Make sure the following files are configured:

- `video_path` to your match video
- `model_path` to trained YOLO ball detection weights
- `pitch_model_path` to pitch detection model
- `pitch_image_path` to your pitch background image

---

## 📊 Final Output

Once processing is complete, you will receive:

- Annotated video frames (`Frame_b/`)
- Trajectory mapping image (`mapped_trajectory_on_pitch.png`)
- Ball Speed (`BallSpeed.txt`)
- Bounce Coordinates (`bounce_coords.txt`)
- Printed Summary:
  - Batsman Handedness
  - Ball Line
  - Ball Length
  - Average Ball Speed (in km/h)

---

## 📌 Example Output

```
Cricket Ball Analysis Results:
----------------------------
Batsman Position: right
Ball Line: off stump
Ball Length: good length
Ball Speed: 132.45 km/h
```

---

## 💡 Future Enhancements

- Use LSTM or Kalman Filters for better trajectory smoothing
- Automate stump zone detection via deep learning
- Integrate full PWA to upload and visualize results online
