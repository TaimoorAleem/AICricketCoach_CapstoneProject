# AI Cricket Coach 🏏

AI Cricket Coach is a mobile application utilizes Computer Vision to analyze practice session videos captured from the umpire’s POV, extracting key features like ball speed, line and length. Using these features, a Machine Learning model suggests the most appropriate shots for the batsman to play, improving their decision-making abilities.

### 🏆 First Place CS Capstone Award
This project was ranked First Place for CS Capstone Awards 2025 across all specializations (Data Analytics, Cloud Computing, Game Engineering)

The ranking was determined based on student votes as well as the Capstone Defense Evaluation, of which the
rubric included:

(10%) Suitability to Solve a Real-World Problem  <br>
(22.5%) Technical Relevance – Mobile App Development  <br>
(22.5%) Technical Relevance – Machine Learning and Statistical Analysis  <br>
(22.5%) Technical Relevance – Computer Vision and Cloud Computing  <br>
(22.5%) Solution Construction Process  <br>
(10%) Solution Feasibility 

### 📄 Capstone Project Report:

https://drive.google.com/file/d/16nV_F1458UqtXBYLwEqJtoV6RG1xtwq-/view?usp=sharing

### 🎥 Final Capstone Presentation & Demo:

<a href="https://www.youtube.com/watch?v=KgE6Eg26K0g" target="_blank">
  <img src="https://img.youtube.com/vi/KgE6Eg26K0g/0.jpg" alt="https://www.youtube.com/watch?v=KgE6Eg26K0g" width="340" border="0" />
</a>

### 👥 Capstone Team Members:
**Muhammad Taimoor Aleem** - Project Leader & Lead Mobile Developer<br>
**Shreya Desai** - Cloud Architect & Lead Backend Developer<br>
**Feras Mahmood** - Machine Learning Developer & Risk Analyst<br>
**Rashesh Desai** - Computer Vision Developer



## Features
#### 🤳 **Video Upload**: 

Players can record and upload delivery videos directly from the app.

#### 👁️ **Ball Trajectory Analysis**: 

The system extracts ball speed, line, length, and batsman position from uploaded videos using computer vision techniques.

#### 🏏 **Ideal Shot Recommendation**: 

A custom-trained machine learning model recommends the most appropriate batting shot based on detected ball trajectory.

#### 📈 **Sessions History and Performance Trends**: 

Players can track their shot execution quality and average ball speed across sessions using data visualizations.

#### 🧑‍🏫 **Coach Feedback**: 

Coaches can leave feedback on each of their players' deliveries.

## Design

### 🖋️ Wireframes

| Loading Page | Log In Page | Sign Up Page | Edit Profile Page |
|:------------:|:-----------:|:------------:|:-----------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/1%20-%20Loading%20Screen%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/2%20-%20Log%20In%20Page%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/3%20-%20Sign%20Up%20Page%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/4%20-%20Edit%20Profile%20Page%20Page.jpg?raw=true" width="200"/> |

| Profile Page | Home Page | Sessions History | Session Details |
|:------------:|:---------:|:----------------:|:---------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/5%20-%20Profile%20Page%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/6%20-%20User%20Home%20Page%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/8%20-%20Sessions%20History%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/9%20-%20Session%20Details%20Page.jpg?raw=true" width="200"/> |

| Ideal Shot Recommendation | Analytics Page | Coach Home Page | Add Player (Coach) |
|:--------------------------:|:--------------:|:---------------:|:------------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/11%20-%20Ideal%20Shot%20Recommendation%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/12%20-%20Analytics%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/13%20-%20Coach%20Home%20Page%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/14%20-%20Add%20Player%20for%20Coach%20Page.jpg?raw=true" width="200"/> |

| Player Comparison (Coach) |
|:-------------------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Wireframes/15%20-%20Player%20Comparision%20for%20Coaches%20Page.jpg?raw=true" width="200"/> |

### 📱 Final User Interface Screenshots

| Loading Page | Sign In Page | Sign Up Page | Forgot Password Page |
|:------------:|:------------:|:------------:|:--------------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/0%20-%20Loading%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/1%20-%20Sign%20In%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/2-%20Sign%20Up%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/3%20-%20Forgot%20Password%20Page.jpg?raw=true" width="200"/> |

| Profile Page | Edit Profile | Upload Video | Active Session |
|:------------:|:------------:|:------------:|:--------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/4%20-%20User%20Profile%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/5%20-%20Edit%20Profile%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/6%20-%20Upload%20Video%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/7%20-%20Active%20Session%20Page.jpg?raw=true" width="200"/> |

| Session History | Session Details | Delivery Details 1 | Delivery Details 2 |
|:---------------:|:---------------:|:------------------:|:------------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/8%20-%20Session%20History%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/9%20-%20Session%20Details%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/10%20-%20Delivery%20Details%20Page.jpg?raw=true" width="200"/> | <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/11%20-%20Delivery%20Details%20Page%202.jpg?raw=true" width="200"/> |

| Performance Analytics |
|:----------------------:|
| <img src="https://github.com/TaimoorAleem/AICricketCoach_CapstoneProject/blob/dev/artifacts/Final%20User%20Interface/12%20-%20Performance%20Analytics%20Page.jpg?raw=true" width="200"/> |

## Tech Stack

#### 📱 Mobile Application
Framework: Flutter (Dart)<br>
Architecture: Clean Architecture<br>
Design Patterns: Repository, Singleton, Factory<br>
Libraries: video_player, chewie, bloc, dio, SharedPreferences

#### 🧠 Machine Learning & Computer Vision
Language: Python<br>
Libraries: OpenCV, scikit-learn, imbalanced-learn, joblib<br>
Model: RandomForestClassifier with GridSearchCV + SMOTE<br>
Functionality: Ball trajectory extraction & ideal shot prediction

#### ☁️ Cloud Infrastructure (Google Cloud Platform)
Storage: Google Cloud Storage (for video storage) & Firestore (for user, session & feedback data storage)<br>
Serverless Compute: Cloud Run (for CV & ML inference)<br>
Notifications: Pub/Sub<br>
API Management: API Gateway (REST APIs for mobile app)

## ⚠️ Intellectual Property Notice

Copyright (c) 2025 Muhammad Taimoor Aleem

All rights reserved.

This project, including its codebase, assets, and the core idea, extraction of ball trajectory details and using them to generate ideal shot recommendation using computer vision and machine learning, is the intellectual property of **Muhammad Taimoor Aleem**.

Unauthorized copying, modification, distribution, use, or reuse of this software or any part of its concept, whether for academic, personal, or commercial purposes, is strictly prohibited without explicit, written permission from the copyright owner.

This repository is **not open source** and is provided for portfolio purposes only. 

It may not be reused by:
- External developers or organizations
- Students or researchers referencing this work for academic submission
- Former or current collaborators, including capstone project teammates

Capstone project teammates are permitted to apply the technical knowledge or skills gained during the development of this project (for example in Flutter, Cloud, Machine Learning, Computer Vision) for other personal, academic, or commercial ventures, provided that the idea they pursue is substantially different from the core idea stated above.

Violation of these terms may result in legal action under applicable intellectual property laws.

For licensing inquiries or permissions, please contact: taimooraleem01@gmail.com
