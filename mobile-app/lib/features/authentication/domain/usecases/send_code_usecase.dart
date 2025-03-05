import 'package:ai_cricket_coach/features/authentication/data/models/reset_pw_params.dart';
import 'package:dartz/dartz.dart';
import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/auth_repo.dart';

class SendCodeUseCase extends UseCase<Either, ResetPWParams>{
  @override
  Future<Either> call({ResetPWParams? params}) async {
    return await sl<AuthRepo>().resetpassword(params!);
  }
}
