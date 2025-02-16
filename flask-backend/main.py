from flask import Flask, request, jsonify
import pandas as pd
from shot_recommendation_engine import ShotRecommendationEngine

app = Flask(__name__)

# Initialize the model engine
engine = ShotRecommendationEngine("C:/Users/Feras/Desktop/Personal/SPM/CricketShotAnalysis_Dataset.csv")

# Train the model at server startup
try:
    training_results = engine.train_model()
    print("Model trained successfully on startup!")
    print(f"Training results: {training_results}")
except Exception as e:
    print(f"Error during model training: {e}")

@app.route('/train', methods=['GET'])
def train_model():
    try:
        results = engine.train_model()
        return jsonify({
            'message': 'Model trained successfully',
            'results': results
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/predict', methods=['POST'])
def predict():
    input_data = request.json
    input_df = pd.DataFrame([input_data])
    try:
        prediction_probs = engine.predict(input_df)
        class_probabilities = {shot: prob for shot, prob in zip(engine.label_encoder.classes_, prediction_probs[0])}
        
        # Sort probabilities in descending order
        sorted_shots = sorted(class_probabilities.items(), key=lambda x: x[1], reverse=True)
        
        return jsonify({
            'predicted_ideal_shots': [
                {'shot': shot, 'confidence_score': round(prob * 100, 2)} 
                for shot, prob in sorted_shots if prob > 0  # Only include shots with some probability
            ]
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
