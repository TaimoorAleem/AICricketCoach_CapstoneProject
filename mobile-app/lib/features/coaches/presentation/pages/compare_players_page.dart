import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../resources/service_locator.dart';
import '../bloc/ComparePlayersCubit.dart';
import '../bloc/compare_players_state.dart';
import '../../domain/usecases/get_players_performance_usecase.dart';
import '../widgets/PlayerComparisonChart.dart';

class ComparePlayersPage extends StatelessWidget {
  final List<String> selectedPlayerUids;

  const ComparePlayersPage({super.key, required this.selectedPlayerUids});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComparePlayersCubit(
        getPlayersPerformanceUseCase: sl<GetPlayersPerformanceUseCase>(),
      )..comparePlayers(selectedPlayerUids),
      child: Scaffold(
        appBar: AppBar(title: const Text("Compare Players' Performance")),
        body: BlocBuilder<ComparePlayersCubit, ComparePlayersState>(
          builder: (context, state) {
            if (state is ComparePlayersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ComparePlayersError) {
              return Center(child: Text(state.message));
            } else if (state is ComparePlayersLoaded) {
              return PlayerComparisonChart(playerPerformances: state.playerPerformances);
            }
            return const Center(child: Text("Select two players to compare."));
          },
        ),
      ),
    );
  }
}
