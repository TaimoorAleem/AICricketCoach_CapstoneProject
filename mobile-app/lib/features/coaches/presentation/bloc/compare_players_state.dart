import '../../../analytics/domain/entities/performance.dart';

abstract class ComparePlayersState {}

class ComparePlayersInitial extends ComparePlayersState {}

class ComparePlayersLoading extends ComparePlayersState {}

class ComparePlayersLoaded extends ComparePlayersState {
  final Map<String, List<Performance>> playerPerformances;
  ComparePlayersLoaded(this.playerPerformances);
}

class ComparePlayersError extends ComparePlayersState {
  final String message;
  ComparePlayersError(this.message);
}
