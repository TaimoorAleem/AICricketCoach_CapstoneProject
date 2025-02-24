import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../analytics/domain/entities/performance.dart';

class PlayerComparisonChart extends StatelessWidget {
  final Map<String, List<Performance>> playerPerformances;

  const PlayerComparisonChart({super.key, required this.playerPerformances});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: playerPerformances.entries.map((entry) {
        return Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: entry.value
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.averageSpeed))
                      .toList(),
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blue,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
