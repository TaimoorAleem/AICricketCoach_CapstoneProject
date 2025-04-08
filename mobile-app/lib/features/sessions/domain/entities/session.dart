import 'delivery.dart';

class Session {
  final String sessionId;
  final String date;
  final List<Delivery> deliveries;
  final Map<String, dynamic> performance;

  Session({
    required this.sessionId,
    required this.date,
    required this.deliveries,
    required this.performance,
  });

  Session copyWith({
    String? sessionId,
    String? date,
    List<Delivery>? deliveries,
    Map<String, dynamic>? performance,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      date: date ?? this.date,
      deliveries: deliveries ?? this.deliveries,
      performance: performance ?? this.performance,
    );
  }
}
