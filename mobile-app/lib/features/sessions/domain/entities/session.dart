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
}
