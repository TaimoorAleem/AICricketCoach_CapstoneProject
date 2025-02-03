import '../../domain/entities/performance.dart';

abstract class PerformanceState {}

class PerformanceInitial extends PerformanceState {}

class PerformanceLoading extends PerformanceState {}

class PerformanceLoaded extends PerformanceState {
  final List<Performance> performanceHistory;
  PerformanceLoaded({required this.performanceHistory});
}

class PerformanceError extends PerformanceState {
  final String errorMessage;
  PerformanceError({required this.errorMessage});
}