from shot_recommendation_engine import ShotRecommendationEngine

# Train and save the model locally
engine = ShotRecommendationEngine("CricketShotAnalysis_Dataset.csv")
accuracy = engine.train_model()  

