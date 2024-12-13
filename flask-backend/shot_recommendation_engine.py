# shot_recommendation_engine.py
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder, StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split, StratifiedKFold, GridSearchCV
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from imblearn.over_sampling import SMOTE
from imblearn.pipeline import Pipeline as ImbPipeline

class ShotRecommendationEngine:
    def __init__(self, data_path):
        self.data_path = data_path
        self.model = None
        self.label_encoder = LabelEncoder()

    def load_data(self):
        data = pd.read_csv(self.data_path)
        if "Ideal Shot" not in data.columns:
            raise ValueError("Dataset must contain 'Ideal Shot' column.")
        X = data.drop("Ideal Shot", axis=1)
        y = data["Ideal Shot"]
        y_encoded = self.label_encoder.fit_transform(y)
        return X, y_encoded

    def preprocess_data(self):
        categorical_cols = ["Ball Horizontal Line", "Ball Length"]
        numerical_cols = ["Ball Speed", "Ball Height", "Batsman Position"]
        
        preprocessor = ColumnTransformer(
            transformers=[
                ('num', StandardScaler(), numerical_cols),
                ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_cols)
            ]
        )
        return preprocessor

    def train_model(self):
        X, y_encoded = self.load_data()
        preprocessor = self.preprocess_data()
        pipeline = ImbPipeline(steps=[
            ('preprocessor', preprocessor),
            ('smote', SMOTE(random_state=42)),
            ('classifier', RandomForestClassifier(random_state=42))
        ])
        
        param_grid = {
            'classifier__n_estimators': [50, 100],
            'classifier__max_depth': [10, 20]
        }
        
        stratified_kfold = StratifiedKFold(n_splits=3, shuffle=True, random_state=42)
        grid_search = GridSearchCV(pipeline, param_grid, cv=stratified_kfold, scoring='balanced_accuracy', n_jobs=-1)
        grid_search.fit(X, y_encoded)
        
        self.model = grid_search.best_estimator_

        # Evaluate the model
        X_train, X_test, y_train, y_test = train_test_split(X, y_encoded, test_size=0.2, random_state=42)
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        report = classification_report(y_test, y_pred)
        confusion = confusion_matrix(y_test, y_pred)

        return {
            'best_params': grid_search.best_params_,
            'accuracy': accuracy,
            'classification_report': report,
            'confusion_matrix': confusion.tolist()
        }

    def predict(self, X):
        if not self.model:
            raise Exception("Model has not been trained yet.")
        return self.model.predict_proba(X)
