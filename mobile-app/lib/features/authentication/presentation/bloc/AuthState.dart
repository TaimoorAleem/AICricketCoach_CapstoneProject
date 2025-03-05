abstract class AuthState {}

class DisplayLoadingPage extends AuthState {}

class Authenticated extends AuthState {
  final String uid;
  Authenticated({required this.uid});
}

class CoachAuthenticated extends AuthState {
  final String uid;
  CoachAuthenticated({required this.uid});
}

class UnAuthenticated extends AuthState {}
