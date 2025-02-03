import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../bloc/performance_cubit.dart';
import '../bloc/performance_state.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PerformanceCubit()..getPerformanceHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Performance History'),
          backgroundColor: Colors.green, // Set primary color for consistency
        ),
        body: BlocBuilder<PerformanceCubit, PerformanceState>(
          builder: (context, state) {
            if (state is PerformanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PerformanceError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is PerformanceLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildLegends(),
                    const SizedBox(height: 16),
                    _buildLineChart(state.performanceHistory),
                  ],
                ),
              );
            }
            return const Center(child: Text('No performance data available.'));
          },
        ),
      ),
    );
  }

  /// 🎨 Adds Legends for color representation
  Widget _buildLegends() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.blue, "Accuracy"),
        const SizedBox(width: 10),
        _legendItem(Colors.green, "Speed"),
        const SizedBox(width: 10),
        _legendItem(Colors.red, "Execution Rating"),
      ],
    );
  }

  /// 🏷️ Widget for an individual legend item
  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  /// 📈 Line Chart Widget with Corrected Data Handling
  Widget _buildLineChart(List<dynamic> performanceHistory) {
    return SizedBox(
      height: 300, // Reduced height for better visibility
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= performanceHistory.length) {
                    return const Text('');
                  }
                  return Text(
                    _formatDate(performanceHistory[index]['date']),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  );
                },
                reservedSize: 32,
              ),
            ),
          ),
          lineBarsData: [
            _lineChartBarData(performanceHistory, 'averageAccuracy', Colors.blue),
            _lineChartBarData(performanceHistory, 'averageSpeed', Colors.green),
            _lineChartBarData(performanceHistory, 'averageExecutionRating', Colors.red),
          ],
        ),
      ),
    );
  }

  /// 📊 Line Chart Data Processing with Correct API Data Mapping
  LineChartBarData _lineChartBarData(List<dynamic> performanceHistory, String metric, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: true),
      spots: performanceHistory.asMap().entries.map((entry) {
        final index = entry.key;
        final performanceData = entry.value['performance'][0]; // Extracting first performance object

        return FlSpot(index.toDouble(), performanceData[metric].toDouble());
      }).toList(),
    );
  }

  /// 📆 Formats Date for X-axis
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('MMM yyyy').format(parsedDate); // Example: "Nov 2024"
  }
}
