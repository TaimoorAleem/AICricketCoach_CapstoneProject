import 'package:dartz/dartz.dart';
import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../../data/models/login_req_params.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase extends UseCase<Either<String, Map<String, dynamic>>, LoginReqParams> {
  @override
  Future<Either<String, Map<String, dynamic>>> call({LoginReqParams? params}) async {
    if (params == null) {
      return Left("Login parameters cannot be null");
    }
    return await sl<AuthRepo>().login(params);
  }
}
