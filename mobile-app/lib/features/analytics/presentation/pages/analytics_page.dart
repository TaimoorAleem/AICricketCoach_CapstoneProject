import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/entities/performance.dart';
import '../bloc/performance_cubit.dart';
import '../bloc/performance_state.dart';
import '../../domain/usecases/get_performance_history_usecase.dart';

class AnalyticsPage extends StatelessWidget {
  final List<String> playerUids;

  const AnalyticsPage({super.key, required this.playerUids});

  factory AnalyticsPage.singlePlayer({required String playerUid}) {
    return AnalyticsPage(playerUids: [playerUid]);
  }

  factory AnalyticsPage.comparePlayers({required String playerUid1, required String playerUid2}) {
    return AnalyticsPage(playerUids: [playerUid1, playerUid2]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PerformanceCubit(getPerformanceHistoryUseCase: sl<GetPerformanceHistoryUseCase>());
        cubit.getPerformanceHistory(playerUids);
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Performance Analytics'),
          backgroundColor: const Color(0xFF001E04),
        ),
        body: BlocBuilder<PerformanceCubit, PerformanceState>(
          builder: (context, state) {
            if (state is PerformanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PerformanceError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is PerformanceLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    _buildSubheading(),
                    if (playerUids.length == 2) _buildLegend(),
                    const SizedBox(height: 16),
                    _buildChart(state.performanceHistory, 'Average Ball Speed (km/h)', (p) => p.averageSpeed, 50, 150),
                    const SizedBox(height: 16),
                    _buildChart(state.performanceHistory, 'Average Batting Performance \n(out of 10)', (p) => p.averageExecutionRating, 0, 10),
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

  /// 📝 Subheading dynamically updates based on comparison mode
  Widget _buildSubheading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        playerUids.length == 1
            ? "The performance of your last 5 sessions is visualized below."
            : "The comparison between the two players is visualized below.",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 🏷️ Legend showing player names with their respective colors
  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem("Player 1", Colors.blue),
          const SizedBox(width: 20),
          _legendItem("Player 2", Colors.red),
        ],
      ),
    );
  }

  /// 📌 Legend item for a single player (color + name)
  Widget _legendItem(String playerName, Color color) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(
          playerName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  /// 📊 Builds a line chart for performance metrics
  Widget _buildChart(
      Map<String, List<Performance>> performanceHistory,
      String title,
      double Function(Performance) getY,
      double minY,
      double maxY,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return _buildXLabel(value, performanceHistory);
                    },
                    reservedSize: 55,
                    interval: 1,
                  ),
                ),
              ),
              lineBarsData: playerUids.map((uid) {
                Color lineColor = playerUids.length == 1 ? Colors.blue : (uid == playerUids[0] ? Colors.blue : Colors.red);
                return _lineChartBarData(performanceHistory[uid] ?? [], getY, lineColor);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// 📈 Line chart styling
  LineChartBarData _lineChartBarData(List<Performance> performanceHistory, double Function(Performance) getY, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      spots: performanceHistory
          .asMap()
          .entries
          .map((entry) => FlSpot(entry.key.toDouble(), getY(entry.value)))
          .toList(),
    );
  }

  /// 📆 Formats Date for X-axis
  Widget _buildXLabel(double value, Map<String, List<Performance>> performanceHistory) {
    int index = value.toInt();
    if (performanceHistory.isEmpty || index < 0) {
      return const SizedBox.shrink();
    }

    List<Performance> sortedDates = performanceHistory.values.expand((e) => e).toList();
    sortedDates.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    if (index >= sortedDates.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 45.0),
      child: Transform.rotate(
        angle: -0.5,
        child: Text(
          _formatDate(sortedDates[index].date),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }

  /// 📆 Formats Date for readability
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yy').format(parsedDate);
  }
}
