import '../../../../resources/usecase.dart';

class IsAuthenticatedUseCase extends UseCase<bool,dynamic> {

  @override
  Future<bool> call({params}) async {
    return true; // TODO: replace false; with await sl<AuthRepo>().isAuthenticated(); to allow user to stay signed in after switching app
  }

}