import 'package:flutter/material.dart';
import '../../domain/entities/delivery.dart';
import '../pages/delivery_details_page.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final String sessionId; // ✅ Session ID required for feedback
  final String playerId;  // ✅ Player ID added for tracking

  const DeliveryCard({Key? key, required this.delivery, required this.sessionId, required this.playerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text('Delivery ID: ${delivery.deliveryId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Speed: ${delivery.speed} km/h'),
            Text('Accuracy: ${delivery.accuracy}%'),
            Text('Ideal Shot: ${delivery.idealShot}'),
            Text('Execution Rating: ${delivery.executionRating}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to the DeliveryDetailsPage and pass sessionId & playerId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailsPage(
                delivery: delivery,
                sessionId: sessionId, // ✅ Ensure sessionId is passed
                playerId: playerId,   // ✅ Ensure playerId is passed
              ),
            ),
          );
        },
      ),
    );
  }
}
