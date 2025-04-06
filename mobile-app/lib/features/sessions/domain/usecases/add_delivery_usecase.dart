import 'package:dartz/dartz.dart';
import '../entities/delivery.dart';
import '../repositories/sessions_repository.dart';

class AddDeliveryUseCase {
  final SessionsRepository repository;

  AddDeliveryUseCase(this.repository);

  Future<Either<String, void>> call({
    required String playerId,
    required String sessionId,
    required Delivery delivery,
  }) {
    return repository.addDelivery(
      playerId: playerId,
      sessionId: sessionId,
      delivery: delivery,
    );
  }
}
