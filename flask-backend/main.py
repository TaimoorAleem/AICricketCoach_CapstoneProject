from flask import Flask, request, jsonify
import pandas as pd
from shot_recommendation_engine import ShotRecommendationEngine

app = Flask(__name__)

# Initialize the model engine
engine = ShotRecommendationEngine("C:/Users/Feras/Desktop/Capstone proj/Expanded_CricketShotAnalysis_Dataset.csv")

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
        predicted_classes = prediction_probs.argmax(axis=1)
        predicted_shots = engine.label_encoder.inverse_transform(predicted_classes)

        return jsonify({
            'predicted_ideal_shots': predicted_shots.tolist(),
            'confidence_scores': prediction_probs.max(axis=1).tolist()
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
