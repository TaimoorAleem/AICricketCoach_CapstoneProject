
import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/auth_repo.dart';

class LogOutUseCase extends UseCase<bool,dynamic> {

  @override
  Future<bool> call({params}) async {
    return await sl<AuthRepo>().logout();
  }

}