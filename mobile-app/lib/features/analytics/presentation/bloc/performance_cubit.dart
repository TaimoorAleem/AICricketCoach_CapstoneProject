import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/performance.dart';
import '../../domain/usecases/get_performance_history_usecase.dart';
import 'performance_state.dart';

class PerformanceCubit extends Cubit<PerformanceState> {
  final GetPerformanceHistoryUseCase getPerformanceHistoryUseCase;

  PerformanceCubit({required this.getPerformanceHistoryUseCase}) : super(PerformanceInitial());

  Future<void> getPerformanceHistory(List<String> playerUids) async {
    emit(PerformanceLoading());

    final Either<String, Map<String, List<Performance>>> result =
    await getPerformanceHistoryUseCase(playerUids: playerUids);

    result.fold(
          (error) {
        emit(PerformanceError(errorMessage: error));
      },
          (performanceData) {
        try {
          emit(PerformanceLoaded(performanceHistory: performanceData));
        } catch (e) {
          emit(PerformanceError(errorMessage: "Error parsing performance data: $e"));
        }
      },
    );
  }
}
