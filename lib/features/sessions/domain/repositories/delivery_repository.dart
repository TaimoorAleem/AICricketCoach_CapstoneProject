import '../entities/delivery.dart';

abstract class DeliveryRepository {
  /// Retrieves all deliveries for a specific session.
  /// Returns a `DataState` with either a list of `Delivery` objects (success) or an error (failure).
  Future<List<DeliveryEntity>> getDeliveriesForSession(String sessionId);

  /// Retrieves a specific delivery by its ID.
  /// Returns a `DataState` with the `Delivery` object (success) or an error (failure).
  Future<DeliveryEntity> getDeliveryById(String sessionId, String deliveryId);

  /// Creates a new delivery for a specific session.
  /// Accepts a `Delivery` object and returns a `DataState` with the created delivery's ID (success) or an error (failure).
  Future<String> createDelivery(String sessionId, DeliveryEntity delivery);

  /// Updates an existing delivery in the database.
  /// Accepts a `Delivery` object and returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<bool> updateDelivery(String sessionId, DeliveryEntity delivery);

  /// Deletes a delivery by its ID for a specific session.
  /// Returns a `DataState` with a boolean indicating success (true) or failure (false).
  Future<bool> deleteDelivery(String sessionId, String deliveryId);
}