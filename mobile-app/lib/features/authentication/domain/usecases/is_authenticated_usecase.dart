
import '../../../../resources/service_locator.dart';
import '../../../../resources/usecase.dart';
import '../repositories/auth_repo.dart';

class IsAuthenticatedUseCase extends UseCase<bool,dynamic> {

  @override
  Future<bool> call({params}) async {
    return false; // TODO: replace false; with await sl<AuthRepo>().isAuthenticated(); to allow user to stay signed in after switching app
  }

}