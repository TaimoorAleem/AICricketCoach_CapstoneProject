import 'delivery.dart';

class Session {
  final String sessionId;
  final String date;
  final List<Delivery> deliveries;

  Session({
    required this.sessionId,
    required this.date,
    required this.deliveries,
  });
}