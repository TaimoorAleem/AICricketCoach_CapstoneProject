import 'package:flutter/material.dart';
import 'package:ai_cricket_coach/features/sessions/domain/entities/delivery.dart';
import 'package:ai_cricket_coach/features/sessions/presentation/pages/delivery_details_page.dart'; // Update to the actual path of DeliveryDetailsPage

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;

  const DeliveryCard({Key? key, required this.delivery}) : super(key: key);

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
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to the DeliveryDetailsPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailsPage(delivery: delivery),
            ),
          );
        },
      ),
    );
  }
}