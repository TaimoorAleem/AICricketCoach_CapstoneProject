import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../resources/service_locator.dart';
import '../bloc/performance_cubit.dart';
import '../../domain/usecases/get_performance_history_usecase.dart';

class AnalyticsPage extends StatelessWidget {
  final List<String> playerUids;
  final bool useHardcodedData;

  const AnalyticsPage({
    super.key,
    required this.playerUids,
    this.useHardcodedData = false,
  });

  factory AnalyticsPage.singlePlayer({required String playerUid, bool useHardcoded = false}) {
    return AnalyticsPage(playerUids: [playerUid], useHardcodedData: useHardcoded);
  }

  factory AnalyticsPage.comparePlayers({required String playerUid1, required String playerUid2, bool useHardcoded = false}) {
    return AnalyticsPage(playerUids: [playerUid1, playerUid2], useHardcodedData: useHardcoded);
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              _buildSubheading(),
              if (playerUids.length == 2) _buildLegend(),
              const SizedBox(height: 16),
              _buildHardcodedChart("Average Ball Speed (km/h)", [90, 95, 88, 91, 93], [85, 92, 86, 88, 90]),
              const SizedBox(height: 16),
              _buildHardcodedChart("Average Batting Performance (out of 10)", [6.5, 7.0, 8.0, 7.5, 8.5], [5.0, 6.0, 6.5, 7.0, 7.2]),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _legendItem(String playerName, Color color) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(playerName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildHardcodedChart(String title, List<double> data1, List<double> data2) {
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
          width: double.infinity,
          child: LineChart(
            LineChartData(
              minY: data1.reduce((a, b) => a < b ? a : b) - 5,
              maxY: data1.reduce((a, b) => a > b ? a : b) + 5,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 1,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              lineBarsData: [
                _lineChartBarData(data1, Colors.red)
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartBarData _lineChartBarData(List<double> data, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(show: false),
      spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
    );
  }
}