import 'package:flutter/material.dart';
import '../../domain/usecases/predict_shot.dart';
import '../widgets/donut_chart.dart';

class ConfidenceLevelPage extends StatefulWidget {
  final PredictShot predictShot;

  const ConfidenceLevelPage({super.key, required this.predictShot});

  @override
  State<ConfidenceLevelPage> createState() => _ConfidenceLevelPageState();
}

class _ConfidenceLevelPageState extends State<ConfidenceLevelPage> {
  double? confidenceLevel;
  String? shotName;
  bool isLoading = true;
  String? errorMessage;

  // Ball metrics stored in a map
  final Map<String, dynamic> ballMetrics = {
    "Ball Horizontal Line": "leg stump",
    "Ball Length": "good length",
    "Ball Speed": 135.0,
    "Ball Height": 0.9,
    "Batsman Position": 1,
  };

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // API call using ballMetrics
      final result = await widget.predictShot.call(ballMetrics);

      setState(() {
        shotName = result['predicted_ideal_shots']?[0] ?? 'Prediction unavailable';
        confidenceLevel = result['confidence_scores']?[0] * 100 ?? 0.0;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confidence Level Results'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? errorWidget()
              : buildSuccessState(),
    );
  }

  Widget buildSuccessState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Results:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Display Ideal Shot
          Text(
            'The Most Ideal Shot based off ball metrics and positioning:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            shotName ?? 'Prediction unavailable',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Confidence Level Donut Chart
          DonutChart(accuracy: confidenceLevel ?? 0.0),
          const SizedBox(height: 8),
          const Text(
            'Confidence%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // Display Ball Metrics
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ballMetrics.entries.map((entry) {
              return Text(
                "${entry.key}: ${entry.value}",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: $errorMessage',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchPrediction,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
