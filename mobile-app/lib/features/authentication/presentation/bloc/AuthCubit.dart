import 'package:flutter_bloc/flutter_bloc.dart';
import 'AuthState.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void authenticate({required String uid, required String? role}) {
    if (role == 'Coach') {
      emit(CoachAuthenticated(uid: uid));
    } else {
      emit(Authenticated(uid: uid));
    }
  }

  void unauthenticate() {
    emit(UnAuthenticated());
  }
}
