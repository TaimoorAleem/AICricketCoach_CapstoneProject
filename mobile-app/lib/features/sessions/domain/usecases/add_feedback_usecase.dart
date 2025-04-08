import 'package:dartz/dartz.dart';
import '../repositories/sessions_repository.dart';

class AddFeedbackUseCase {
  final SessionsRepository repository;

  AddFeedbackUseCase(this.repository);

  Future<Either<String, void>> call({
    required String playerId,
    required String sessionId,
    required String deliveryId,
    required double battingRating,
    required String feedback,
  }) {
    return repository.addFeedback(
      playerId: playerId,
      sessionId: sessionId,
      deliveryId: deliveryId,
      battingRating: battingRating,
      feedback: feedback,
    );
  }
}
