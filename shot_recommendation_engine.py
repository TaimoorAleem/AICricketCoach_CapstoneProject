import joblib
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder, RobustScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.model_selection import train_test_split, StratifiedKFold, GridSearchCV
from sklearn.metrics import accuracy_score
from imblearn.over_sampling import SMOTE
from imblearn.pipeline import Pipeline as ImbPipeline

class ShotRecommendationEngine:
    def __init__(self, data_path="CricketShotAnalysis_Dataset.csv", 
                 model_path="shot_recommendation_model.pkl", 
                 encoder_path="label_encoder.pkl"):
        self.data_path = data_path
        self.model_path = model_path
        self.encoder_path = encoder_path
        self.model = None
        self.label_encoder = LabelEncoder()

    def load_data(self):
        """Loads dataset and prepares training data."""
        data = pd.read_csv(self.data_path)

        if "Ideal Shot" not in data.columns:
            raise ValueError("Dataset must contain 'Ideal Shot' column.")
        
    
        X = data.drop(columns=["Ideal Shot"])
        y = data["Ideal Shot"]
        y_encoded = self.label_encoder.fit_transform(y)

        return X, y_encoded

    def preprocess_data(self):
        """Defines preprocessing for numeric & categorical features."""
        categorical_cols = ["Ball Horizontal Line", "Ball Length"]
        numerical_cols = ["Ball Speed", "Batsman Position"]  # "Ball Height" is already removed

        preprocessor = ColumnTransformer(
            transformers=[
                ('num', RobustScaler(), numerical_cols),
                ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_cols)
            ]
        )
        return preprocessor

    def train_model(self):
        """Trains the model with hyperparameter tuning and saves it."""
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

        stratified_kfold = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
        grid_search = GridSearchCV(pipeline, param_grid, cv=stratified_kfold, scoring='balanced_accuracy', n_jobs=-1)
        grid_search.fit(X, y_encoded)
        
        self.model = grid_search.best_estimator_
        
        # Save model & label encoder
        joblib.dump(self.model, self.model_path)
        joblib.dump(self.label_encoder, self.encoder_path)
        
        # Evaluate the model
        X_train, X_test, y_train, y_test = train_test_split(X, y_encoded, test_size=0.2, random_state=42)
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)

        print("Model training complete and saved.")
        print("accuracy: ",accuracy)

    def load_model(self):
        """Loads the trained model and label encoder."""
        self.model = joblib.load(self.model_path)
        self.label_encoder = joblib.load(self.encoder_path)

    def predict(self, X):
        if not self.model:
            raise Exception("Model has not been trained yet.")
        return self.model.predict_proba(X)

