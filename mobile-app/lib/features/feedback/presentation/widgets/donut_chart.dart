import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DonutChart extends StatelessWidget {
  final double accuracy;

  const DonutChart({super.key, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      percent: accuracy / 100, // Convert accuracy to a value between 0 and 1
      center: Text(
        '${accuracy.toStringAsFixed(1)}%',
        style: Theme.of(context).textTheme.headlineMedium, // Updated here
      ),
      progressColor: Colors.blue,
      backgroundColor: Colors.grey[300]!,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }
}
