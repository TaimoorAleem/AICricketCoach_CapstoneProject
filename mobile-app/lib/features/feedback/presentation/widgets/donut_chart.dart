import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DonutChart extends StatelessWidget {
  final double accuracy;  // This represents the confidence level as a percentage.

  const DonutChart({
    super.key,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      percent: accuracy / 100, // Convert the accuracy to a value between 0 and 1
      center: Text(
        '${accuracy.toStringAsFixed(1)}%', // Display only the percentage value
        style: TextStyle(
          fontSize: 20.0,  // Adjust font size as needed
          fontWeight: FontWeight.bold,
          color: Colors.white,  // Adjust text color as needed
        ),
      ),
      progressColor: Colors.blue,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
