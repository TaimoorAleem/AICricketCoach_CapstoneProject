import 'package:flutter/material.dart';
import '../../domain/entities/delivery.dart';
import '../pages/delivery_details_page.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final String sessionId;
  final String playerId;

  const DeliveryCard({super.key, required this.delivery, required this.sessionId, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('Delivery ID: ${delivery.deliveryId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Speed: ${delivery.ballSpeed} km/h'),
            Text('Ball Line: ${delivery.ballLine}'),
            Text('Ball Length: ${delivery.ballLength}'),
            if (delivery.feedback != null) Text('Feedback: ${delivery.feedback}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeliveryDetailsPage(
                sessionId: sessionId,
                deliveryId: delivery.deliveryId,
              ),
            ),
          );
        },
      ),
    );
  }
}
