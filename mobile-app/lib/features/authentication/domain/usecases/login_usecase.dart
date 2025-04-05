import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../../data/models/login_req_params.dart';
import '../repositories/auth_repo.dart';

class LoginUseCase extends UseCase<Either,LoginReqParams> {

  @override
  Future<Either> call({LoginReqParams? params}) async {
    return await sl<AuthRepo>().login(params!);
  }

}