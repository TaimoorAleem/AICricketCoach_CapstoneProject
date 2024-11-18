#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
from sklearn.preprocessing import LabelEncoder, StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV, train_test_split
from sklearn.metrics import accuracy_score, classification_report

class DataLoader:
    def __init__(self, data_path):
        self.data_path = data_path
        self.data = None
        self.label_encoder = None

    def load_data(self):
        # Load the dataset
        self.data = pd.read_csv(self.data_path)
        # Separate features and target variable
        X = self.data.drop("Ideal Shot", axis=1)
        y = self.data["Ideal Shot"]
        
        # Encode the target variable
        self.label_encoder = LabelEncoder()
        y_encoded = self.label_encoder.fit_transform(y)
        return X, y_encoded




# In[3]:


class ShotRecommendationEngine:
    def __init__(self, data_loader):
        self.data_loader = data_loader
        self.model = None

    def preprocess_and_train(self):
        X, y_encoded = self.data_loader.load_data()
        
        # Define categorical and numerical columns
        categorical_cols = ["Ball Horizontal Line", "Ball Length"]
        numerical_cols = ["Ball Speed", "Ball Height", "Batsman Position"]
        
        # Preprocessing pipeline
        preprocessor = ColumnTransformer(
            transformers=[
                ('num', StandardScaler(), numerical_cols),
                ('cat', OneHotEncoder(), categorical_cols)
            ])
        
        # Create an SVM model pipeline
        svm_pipeline = Pipeline(steps=[
            ('preprocessor', preprocessor),
            ('classifier', SVC(kernel='rbf', C=1.0, gamma='scale'))
        ])
        
        # Define hyperparameter grid for GridSearchCV
        param_grid = {
            'classifier__C': [0.1, 1, 10],
            'classifier__gamma': ['scale', 0.001, 0.01, 0.1],
            'classifier__kernel': ['rbf', 'poly']  # Trying both RBF and polynomial kernels
        }
        
        grid_search = GridSearchCV(svm_pipeline, param_grid, cv=5, scoring='accuracy', n_jobs=-1)
        grid_search.fit(X, y_encoded)
        
        self.model = grid_search.best_estimator_
        
        print("Best Parameters:", grid_search.best_params_)

    def evaluate(self):
        X, y_encoded = self.data_loader.load_data()
        # Split data into train and test sets for final evaluation
        X_train, X_test, y_train, y_test = train_test_split(X, y_encoded, test_size=0.2, random_state=42)
        
        self.model.fit(X_train, y_train)
        
        # Predict on the test set
        y_pred = self.model.predict(X_test)
        
        # Evaluate the model
        accuracy = accuracy_score(y_test, y_pred)
        report = classification_report(y_test, y_pred, target_names=self.data_loader.label_encoder.classes_)
        
        print("Accuracy:", accuracy)
        print("\nClassification Report:\n", report)

# Usage example
data_loader = DataLoader("C:/Users/Feras/Desktop/Capstone proj/CricketShotAnalysis_Dataset.csv")
engine = ShotRecommendationEngine(data_loader)
engine.preprocess_and_train()
engine.evaluate()

