# 🏏 Shot Recommendation Engine – AICricketCoach

This branch introduces a **Machine Learning module** for cricket shot prediction as part of the **AICricketCoach** project. The model analyzes incoming ball features and recommends the **ideal cricket shot** based on historical data and performance metrics.

---

## 📌 Overview

This engine uses a **Random Forest Classifier** trained on the `CricketShotAnalysis_Dataset.csv` to predict the optimal batting shot given various input parameters like:

- Ball speed
- Ball length
- Ball horizontal line
- Batsman's position

---

## ⚙️ Features

- **Preprocessing Pipeline** with:
  - Robust scaling of numerical features
  - One-hot encoding for categorical columns
  - SMOTE for balancing class distribution

- **Hyperparameter Tuning** via GridSearchCV over:
  - `n_estimators`: [50, 100]
  - `max_depth`: [10, 20]

- **Cross-Validation** using Stratified K-Folds (5 splits)

- **Model Saving/Loading** using `joblib` for reusability

- **Label Encoding** for target variable "Ideal Shot"

---

## ✅ Performance

- The trained model achieves an **accuracy of 87.9%** on the test dataset.
- Balanced accuracy scoring is used for fair evaluation on imbalanced data.

---

## 📁 Key Files

- `shot_recommendation_model.pkl`: Trained ML model
- `label_encoder.pkl`: Label encoder for the target classes
- `CricketShotAnalysis_Dataset.csv`: Source dataset used for training

---

## 🔮 Prediction API

Once trained, the model can return **probabilities for each shot class** given new ball input data via the `predict()` method.

---

## 🚀 Future Enhancements

- Integration with real-time ball tracking input from Flutter
- Model export to ONNX or TensorFlow Lite for mobile inference
- Explainable AI integration for shot recommendation transparency

---

Developed as part of the Capstone Project – `AICricketCoach`.
