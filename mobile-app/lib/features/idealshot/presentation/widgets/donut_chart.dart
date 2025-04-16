import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DonutChart extends StatelessWidget {
  final double accuracy;
  final double radius;

  const DonutChart({
    super.key,
    required this.accuracy,
    this.radius = 120.0, // Default radius
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: 15.0,
      percent: accuracy / 100,
      center: Text(
        '${accuracy.toStringAsFixed(1)}%',
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      progressColor: Colors.blue,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
