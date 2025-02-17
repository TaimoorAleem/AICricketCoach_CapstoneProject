import 'package:ai_cricket_coach/features/user_profile/data/models/EditProfileReqParams.dart';
import 'package:dartz/dartz.dart';

import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/auth_repo.dart';
class CreateProfileUseCase extends UseCase<Either,EditProfileReqParams> {

  @override
  Future<Either> call({EditProfileReqParams? params}) async {
    return await sl<AuthRepo>().createProfile(params!);
  }

}