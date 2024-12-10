import '../../domain/entities/delivery.dart';

abstract class DeliveryState {}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryLoaded extends DeliveryState {
  final Delivery delivery;

  DeliveryLoaded({required this.delivery});
}

class DeliveryError extends DeliveryState {
  final String message;

  DeliveryError({required this.message});
}