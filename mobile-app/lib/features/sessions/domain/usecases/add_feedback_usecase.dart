import 'package:dartz/dartz.dart';
import '../../../../resources/service_locator.dart';
import '../../domain/repositories/sessions_repository.dart';

class AddFeedbackUseCase {
  Future<Either<String, void>> call({
    required String uid,
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double executionRating,
    required String feedback,
  }) async {
    return await sl<SessionsRepository>().addFeedback(
      playerId: playerId,
      sessionId: sessionId,
      deliveryId: deliveryId,
      executionRating: executionRating,
      feedback: feedback,
    );
  }
}
