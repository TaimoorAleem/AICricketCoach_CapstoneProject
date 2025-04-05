import os
import joblib
from flask import Flask, request, jsonify
import pandas as pd
from shot_recommendation_engine import ShotRecommendationEngine

app = Flask(__name__)

# Load trained model at startup
engine = ShotRecommendationEngine()

try:
    engine.load_model()
    print("✅ Model loaded successfully!")
except Exception as e:
    print(f"❌ Error loading model: {str(e)}")
    exit(1)  # Exit if the model fails to load

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for Cloud Run."""
    return jsonify({"status": "healthy"}), 200

@app.route('/predict', methods=['POST'])
def predict():
    """API endpoint to make predictions."""
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
    port = int(os.environ.get("PORT", 8080))  # Ensure PORT is taken from env variables
    app.run(host='0.0.0.0', port=port)  # Required for Cloud Run
