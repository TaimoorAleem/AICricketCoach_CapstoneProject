import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_sessions_usecase.dart';
import 'sessions_state.dart';

class SessionsCubit extends Cubit<SessionsState> {
  final GetSessionsUseCase getSessionsUseCase;

  SessionsCubit({required this.getSessionsUseCase}) : super(SessionsInitial());

  void fetchSessions(String uid) async {
    emit(SessionsLoading());
    final result = await getSessionsUseCase.call(uid);
    result.fold(
          (error) => emit(SessionsError(message: error)),
          (sessions) => emit(SessionsLoaded(sessions: sessions)),
    );
  }
}
