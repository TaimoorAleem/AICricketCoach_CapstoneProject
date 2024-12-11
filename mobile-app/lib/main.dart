import 'package:flutter/material.dart';
import 'features/feedback/presentation/pages/prediction_page.dart';
import 'features/feedback/domain/usecases/predict_shot.dart';
import 'features/feedback/data/repositories/shot_repository_impl.dart';
import 'features/feedback/data/data_sources/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up dependencies
    final apiService = ApiService('http://127.0.0.1:5000'); // Replace with your Flask server URL
    final repository = ShotRepositoryImpl(apiService);
    final predictShot = PredictShot(repository);

    return MaterialApp(
      title: 'Accuracy Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black, // Default background color for all screens
      ),
      home: ConfidenceLevelPage(predictShot: predictShot),
    );
  }
}
