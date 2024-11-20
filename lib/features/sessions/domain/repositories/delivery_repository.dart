import '../entities/delivery.dart';
import '../../../../core/resources/data_state.dart';

abstract class DeliveryRepository {
  /// Retrieves all deliveries for a specific session.
  /// Returns a `DataState` with either a list of `Delivery` objects (success) or an error (failure).
  Future<DataState<List<Delivery>>> getDeliveriesForSession(String sessionId);

  /// Retrieves a specific delivery by its ID.
  /// Returns a `DataState` with the `Delivery` object (success) or an error (failure).
  Future<DataState<Delivery>> getDeliveryById(String sessionId, String deliveryId);

  /// Creates a new delivery for a specific session.
  /// Accepts a `Delivery` object and returns a `DataState` with the created delivery's ID (success) or an error (failure).
  Future<DataState<String>> createDelivery(String sessionId, Delivery delivery);

  /// Updates an existing delivery in the database.
  /// Accepts a `Delivery` object and returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<DataState<bool>> updateDelivery(String sessionId, Delivery delivery);

  /// Deletes a delivery by its ID for a specific session.
  /// Returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<DataState<bool>> deleteDelivery(String sessionId, String deliveryId);
}