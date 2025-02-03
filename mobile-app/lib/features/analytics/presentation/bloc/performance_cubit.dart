import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_performance_history_usecase.dart';
import '../../../../resources/service_locator.dart';
import 'performance_state.dart';

class PerformanceCubit extends Cubit<PerformanceState> {
  final GetPerformanceHistoryUseCase _getPerformanceHistoryUseCase;

  PerformanceCubit()
      : _getPerformanceHistoryUseCase = sl<GetPerformanceHistoryUseCase>(),
        super(PerformanceInitial());

  void getPerformanceHistory() async {
    emit(PerformanceLoading());
    final result = await _getPerformanceHistoryUseCase.call();
    result.fold(
          (error) => emit(PerformanceError(errorMessage: error)),
          (performance) => emit(PerformanceLoaded(performanceHistory: performance)),
    );
  }
}
