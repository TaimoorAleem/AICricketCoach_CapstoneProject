import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final GetSessionsUseCase getSessionsUseCase;

  SessionsCubit({required this.getSessionsUseCase}) : super(SessionsInitial());

  void getSessions() async {
    emit(SessionsLoading());
    final result = await getSessionsUseCase.call();
    result.fold(
          (error) => emit(SessionsError(errorMessage: error)),
          (sessions) => emit(SessionsLoaded(sessions: sessions)),
    );
  }
}