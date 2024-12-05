import 'delivery.dart';

class Session {
  final String sessionId;
  final DateTime date;
  final double averageSpeed;
  final double averageAccuracy;
  final double averageExecutionRating;
  final List<Delivery> deliveries; // References to delivery entities

  Session({
    required this.sessionId,
    required this.date,
    required this.averageSpeed,
    required this.averageAccuracy,
    required this.averageExecutionRating,
    required this.deliveries,
  });
}