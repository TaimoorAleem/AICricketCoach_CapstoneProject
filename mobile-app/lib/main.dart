import 'package:flutter/material.dart';
import 'injection_container.dart'; // Dependency Injection
import 'presentation/pages/ideal_shot_page.dart';
import 'domain/usecases/predict_shot.dart';

void main() {
  // Initialize Dependency Injection
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shot Prediction App',
      theme: ThemeData.dark(), // Dark theme for a modern UI
      home: IdealShotPage(predictShot: sl<PredictShot>()), // Display the page
    );
  }
}
