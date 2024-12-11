import '../../domain/entities/session.dart';

abstract class SessionsState {}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<Session> sessions;

  SessionsLoaded({required this.sessions});
}

class SessionsError extends SessionsState {
  final String errorMessage;

  SessionsError({required this.errorMessage});
}
