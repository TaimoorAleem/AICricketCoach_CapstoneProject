import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final String title;
  final List<double> data1;
  final List<double>? data2;

  const LineChartWidget({
    super.key,
    required this.title,
    required this.data1,
    this.data2,
  });

  factory LineChartWidget.hardcoded(String title) {
    if (title.contains("Speed")) {
      return LineChartWidget(
        title: title,
        data1: [90, 95, 88, 91, 93],
      );
    } else {
      return LineChartWidget(
        title: title,
        data1: [6.5, 7.0, 8.0, 7.5, 8.5],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: data1.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                  isCurved: true,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
                ),
                if (data2 != null)
                  LineChartBarData(
                    spots: data2!.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                    gradient: const LinearGradient(colors: [Colors.red, Colors.pinkAccent]),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}