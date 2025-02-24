import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/service_locator.dart';
import '../../domain/usecases/is_authenticated_usecase.dart';
import '../../../authentication/presentation/bloc/AuthState.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit() : super(DisplayLoadingPage());

  void appStarted() async {
    await Future.delayed(const Duration(seconds: 2));
    var isAuthenticated = await sl < IsAuthenticatedUseCase > ().call();
    if (isAuthenticated) {
      emit(Authenticated());
    } else {
      emit(
          UnAuthenticated()
      );
    }
  }

}
