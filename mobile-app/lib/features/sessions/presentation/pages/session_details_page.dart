import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../widgets/DeliveryCard.dart';

class SessionDetailsPage extends StatelessWidget {
  final Session session;
  final String playerId;

  const SessionDetailsPage({super.key, required this.session, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Session: ${session.sessionId}')),
      body: ListView.builder(
        itemCount: session.deliveries.length,
        itemBuilder: (context, index) {
          final delivery = session.deliveries[index];
          return DeliveryCard(
            delivery: delivery,
            sessionId: session.sessionId,
            playerId: playerId,
          );
        },
      ),
    );
  }
}
