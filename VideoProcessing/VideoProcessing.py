import cv2
import math
import numpy as np

def calculate_distance(prev_point, current_point):
    return math.sqrt((current_point[0] - prev_point[0]) ** 2 + (current_point[1] - prev_point[1]) ** 2)

# Function to calculate speed in km/h (distance/time)
def calculate_speed(distance, fps, scale_m_per_pixel):
    # Speed in pixels per second * fps to convert to pixels/second
    speed_px_per_s = distance * fps
    # Convert speed to meters per second using scale factor (pixels to meters)
    speed_m_per_s = speed_px_per_s * scale_m_per_pixel
    # Convert meters per second to kilometers per hour
    speed_km_per_hr = speed_m_per_s * 3.6
    return speed_km_per_hr

# Function to calculate bounce height in meters (assuming camera calibration gives a scale factor)
def calculate_bounce_height(y_position, scale_m_per_pixel, frame_height):
    
    height_ratio = (frame_height - y_position) / frame_height  
    bounce_height = 0.2 + height_ratio * (1.5 - 0.2)  
    return bounce_height

# Initialize video capture
cap = cv2.VideoCapture('Ball.mp4')

# Read first frame to initialize variables
ret, frame = cap.read()
prev_frame = frame

# Initialize variables
prev_position = None
prev_time = None

# FPS (Frames per second) of the video
fps = cap.get(cv2.CAP_PROP_FPS)


scale_m_per_pixel = 0.01  
frame_height = frame.shape[0]  

# Define a threshold for detecting the bounce (you can adjust this based on the Y-coordinate of the ground)
ground_threshold = 150  
prev_speeds = []

# Loop through video frames
while ret:
    ret, frame = cap.read()
    if not ret:
        break
    
   
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    
    lower_red = np.array([0, 120, 70])   # Lower bound for color
    upper_red = np.array([10, 255, 255]) # Upper bound for color
    
   
    mask = cv2.inRange(hsv, lower_red, upper_red)
    
 
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, np.ones((5, 5), np.uint8))
    
   
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

   
    for contour in contours:
        area = cv2.contourArea(contour)
        if area > 100:  
            x, y, w, h = cv2.boundingRect(contour)
            
            # Calculate the center of the bounding box (potential ball location)
            center = (x + w // 2, y + h // 2)
            
            # Draw a circle around the detected ball
            cv2.circle(frame, center, 10, (0, 255, 0), 2)
            
           
            if prev_position:
                distance = calculate_distance(prev_position, center)
                
                # Print distance to debug (see how much the ball is moving between frames)
                print(f"Distance: {distance:.2f} pixels")
                
                if prev_time:
                    # Calculate speed in km/h
                    speed_km_hr = calculate_speed(distance, fps, scale_m_per_pixel)
                    
                   
                    prev_speeds.append(speed_km_hr)
                    if len(prev_speeds) > 10: 
                        prev_speeds.pop(0)
                    
                    smoothed_speed = np.mean(prev_speeds)
                    
                    cv2.putText(frame, f"Speed: {smoothed_speed:.2f} km/h", (center[0] + 10, center[1] - 10),
                                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA)
                   
                    print(f"Smoothed Speed: {smoothed_speed:.2f} km/h")

            # Detecting bounce: check if the ball is near the ground (Y position threshold)
            print(f"Ball Y Position: {center[1]}")  # Print Y-coordinate of the ball to debug

            if center[1] < ground_threshold:  
                bounce_height = calculate_bounce_height(center[1], scale_m_per_pixel, frame_height)
                cv2.putText(frame, f"Bounce Height: {bounce_height:.2f} m", 
                            (center[0] + 10, center[1] - 30), cv2.FONT_HERSHEY_SIMPLEX, 
                            0.5, (255, 255, 255), 2, cv2.LINE_AA)
                
                print(f"Bounce Height: {bounce_height:.2f} m")

         
            prev_position = center
            prev_time = cv2.getTickCount() / cv2.getTickFrequency()

    
    cv2.imshow('Ball Tracking', frame)
    
    
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


cap.release()
cv2.destroyAllWindows()


