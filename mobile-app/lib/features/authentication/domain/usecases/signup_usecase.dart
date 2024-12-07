import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../../data/models/signup_req_params.dart';
import '../repositories/auth_repo.dart';

class SignupUseCase extends UseCase<Either,SignupReqParams> {

  @override
  Future<Either> call({SignupReqParams? params}) async {
    return await sl<AuthRepo>().signup(params!);
  }

}