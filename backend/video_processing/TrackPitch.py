import cv2
import numpy as np


image_path = "pitch.jpeg"
image = cv2.imread(image_path)

stumps_x = image.shape[1] // 2  # center of the image width-wise
stumps_y = int(image.shape[0] * 0.05)  
yorker_length = stumps_y + int(image.shape[0] * 0.07)  # York-length distance from the far end
full_pitched_length = stumps_y + int(image.shape[0] * 0.1)
good_length = stumps_y + int(image.shape[0] * 0.15)
short_pitched_length = stumps_y + int(image.shape[0] * 0.2)
bouncer_length = stumps_y + int(image.shape[0] * 0.3)

# Draw lines for each delivery length from the far-end stumps
cv2.line(image, (0, yorker_length), (image.shape[1], yorker_length), (0, 0, 255), 2)
cv2.putText(image, 'Yorker', (10, yorker_length - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

cv2.line(image, (0, full_pitched_length), (image.shape[1], full_pitched_length), (0, 255, 0), 2)
cv2.putText(image, 'Full Pitched', (10, full_pitched_length - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)

cv2.line(image, (0, good_length), (image.shape[1], good_length), (255, 0, 0), 2)
cv2.putText(image, 'Good Length', (10, good_length - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 0), 2)

cv2.line(image, (0, short_pitched_length), (image.shape[1], short_pitched_length), (255, 255, 0), 2)
cv2.putText(image, 'Short Pitched', (10, short_pitched_length - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 0), 2)

cv2.line(image, (0, bouncer_length), (image.shape[1], bouncer_length), (255, 0, 255), 2)
cv2.putText(image, 'Bouncer', (10, bouncer_length - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 255), 2)

# Create a transparent overlay
overlay = image.copy()
line_thickness = 20  

# Shift the line slightly to the right by adjusting the x-coordinate
shift = 15  
line_length = 530  

# Drawing a thicker line for middle stump (yellow color)
cv2.line(overlay, (stumps_x + shift, stumps_y), (stumps_x + shift, stumps_y + line_length), (255, 255, 102), line_thickness)

# Adding text on the overlay with the same yellow color
cv2.putText(overlay, 'Middle Stump Delivery', (stumps_x + shift + 10, stumps_y + line_length // 2), 
            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 102), 2)

# Blend the overlay with the original image
alpha = 0.3  # Control the transparency level (0: fully transparent, 1: fully opaque)
cv2.addWeighted(overlay, alpha, image, 1 - alpha, 0, image)

# Function to classify the ball's delivery type based on its position
def classify_ball_delivery(ball_x, ball_y, pitch_width, pitch_length, stumps_x):
    # Check if the ball is outside the pitch (wide ball)
    if ball_x < 0 or ball_x > pitch_width or ball_y < 0 or ball_y > pitch_length:
        return "Wide Ball Delivery"
    
    # Check if the ball is within the thickness of the middle stump line (middle stump delivery)
    if abs(ball_x - stumps_x) <= line_thickness:
        return "Middle Stump Delivery"
    
    # Check if the ball is on the right side of the middle stump (leg stump delivery)
    if ball_x > stumps_x:
        return "Leg Stump Delivery"
    
    # Check if the ball is on the left side of the middle stump (off stump delivery)
    if ball_x < stumps_x:
        return "Off Stump Delivery"
    
    return "Middle Stump Delivery"  # Default case for ball on middle stump

def classify_delivery_line(ball_y):
    if ball_y < yorker_length:
        return "Yorker Pitched"
    elif ball_y < full_pitched_length:
        return "Full Length Pitched"
    elif ball_y < good_length:
        return "Good Length"
    elif ball_y < short_pitched_length:
        return "Short Pitched"
    elif ball_y < bouncer_length:
        return "Bouncer"
    else:
        return "No Ball Detected"

# Example of ball positions (replace these with real values)
ball_x = 460 
ball_y = 250  
delivery_type = classify_ball_delivery(ball_x, ball_y, image.shape[1], image.shape[0], stumps_x)
delivery_line = classify_delivery_line(ball_y)
print(f"Ball Delivery: {delivery_type}")
print(f"Ball is in the: {delivery_line}")

# Highlight the ball with a larger circle and more visible color
ball_color = (0, 0, 255) 
ball_radius = 12
cv2.circle(image, (ball_x, ball_y), ball_radius, ball_color, -1)  
cv2.putText(image, delivery_type, (10, image.shape[0] - 20), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

output_path = "marked_pitch_with_middle_stump_delivery_and_ball.jpeg"
cv2.imwrite(output_path, image)

output_path
