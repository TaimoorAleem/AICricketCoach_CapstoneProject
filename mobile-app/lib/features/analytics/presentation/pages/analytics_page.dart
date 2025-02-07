import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/performance.dart';
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
              // ✅ Sort performance history by date (oldest to newest)
              List<Performance> sortedHistory = List.from(state.performanceHistory.cast<Performance>());
              sortedHistory.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

              return SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    _buildInfoText(),
                    const SizedBox(height: 16),
                    _buildSingleChart(
                      sortedHistory,
                      'Balling Accuracy (%)',
                      Colors.blue,
                          (p) => p.averageAccuracy,
                      0,
                      100,
                    ),
                    const SizedBox(height: 16),
                    _buildSingleChart(
                      sortedHistory,
                      'Balling Speed (km/h)',
                      Colors.green,
                          (p) => p.averageSpeed,
                      50,
                      150,
                    ),
                    const SizedBox(height: 16),
                    _buildSingleChart(
                      sortedHistory,
                      'Batting Performance (out of 10)',
                      Colors.red,
                          (p) => p.averageExecutionRating,
                      0,
                      10,
                    ),
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

  /// 📝 Displays an information message instead of the legend
  Widget _buildInfoText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        "The performance of your last 5 sessions are visualized below.",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 📊 Builds an individual line chart for a given metric with specified Y-axis range
  Widget _buildSingleChart(
      List<Performance> performanceHistory,
      String title,
      Color color,
      double Function(Performance) getY,
      double minY,
      double maxY,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // ✅ Center align chart title
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20), // ✅ Add spacing below title
        SizedBox(
          height: 250, // Height for each chart
          child: LineChart(
            LineChartData(
              minY: minY, // ✅ Set minimum Y-axis value
              maxY: maxY, // ✅ Set maximum Y-axis value
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                rightTitles: AxisTitles( // ✅ Hide Right Axis
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles( // ✅ Hide Top Axis
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= performanceHistory.length) {
                        return const SizedBox.shrink();
                      }
                      // ✅ Now only shows exact received dates
                      return Padding(
                        padding: const EdgeInsets.only(top: 20.0, right: 45.0), // ✅ Keeps bottom labels inside bounds
                        child: Transform.rotate(
                          angle: -0.5, // ✅ Adjusted rotation for better readability
                          child: Text(
                            _formatDate(performanceHistory[index].date),
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      );
                    },
                    reservedSize: 55, // ✅ Increased to prevent cutting off last date
                    interval: 1, // ✅ Only display exact dates from received data
                  ),
                ),
              ),
              lineBarsData: [
                _lineChartBarData(performanceHistory, getY, color),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 📈 Creates Line Chart Bar Data with Translucent Fill
  LineChartBarData _lineChartBarData(
      List<Performance> performanceHistory,
      double Function(Performance) getY,
      Color color,
      ) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true, // ✅ Enables the translucent fill effect
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.4), // ✅ More visible at the top
            color.withOpacity(0.1), // ✅ More transparent at the bottom
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      spots: performanceHistory
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), getY(entry.value))) // ✅ Fix: Directly use Performance properties
          .toList(),
    );
  }

  /// 📆 Formats Date for X-axis in "dd MMM yy" (e.g., "20 Nov 24")
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yy').format(parsedDate); // Example: "20 Nov 24"
  }
}
