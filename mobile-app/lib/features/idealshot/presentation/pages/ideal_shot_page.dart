import 'package:flutter/material.dart';
import '../../domain/entities/ideal_shot.dart';

class IdealShotPage extends StatelessWidget {
  final Map<String, dynamic> ballCharacteristics;
  final List<IdealShot> shots;

  const IdealShotPage({super.key, required this.ballCharacteristics, required this.shots});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ideal Shot Recommendations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Ball Characteristics", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...ballCharacteristics.entries.map((e) => Text("${e.key}: ${e.value}")),
            const Divider(height: 30),
            const Text("Predicted Shots", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...shots.map((s) => Text("${s.shot} (${s.confidenceScore.toStringAsFixed(1)}%)")),
          ],
        ),
      ),
    );
  }
}
