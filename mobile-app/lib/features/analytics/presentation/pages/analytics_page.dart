import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../resources/app_colors.dart';
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

  final List<String> sessionDates = const ['Mar 19', 'Mar 26', 'Apr 02', 'Apr 09', 'Apr 16'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = PerformanceCubit(getPerformanceHistoryUseCase: sl<GetPerformanceHistoryUseCase>());
        cubit.getPerformanceHistory(playerUids);
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Performance Analytics',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.secondary,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildSubheading(),
              const SizedBox(height: 16),
              _buildChart(
                title: "Average Ball Speed (km/h)",
                subtitle: "Extracted from video",
                data: [90, 95, 88, 91, 93],
                minY: 80,
                maxY: 100,
                isSpeedChart: true,
              ),
              const SizedBox(height: 20),
              _buildChart(
                title: "Average Batting Performance Rating",
                subtitle: "Rated by your coach",
                data: [6.5, 7.0, 8.0, 7.5, 8.5],
                minY: 0,
                maxY: 10,
                isSpeedChart: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubheading() {
    return Text(
      playerUids.length == 1
          ? "Your performance across 5 recent sessions is shown below"
          : "The comparison between the two players is visualized below.",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Nunito',
        color: Colors.white70,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildChart({
    required String title,
    required String subtitle,
    required List<double> data,
    required double minY,
    required double maxY,
    required bool isSpeedChart,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Nunito',
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < sessionDates.length) {
                        return Text(
                          sessionDates[index],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    },
                    reservedSize: 40,
                    interval: 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: isSpeedChart ? 5 : 2,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    reservedSize: 40,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: false),
                  spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
