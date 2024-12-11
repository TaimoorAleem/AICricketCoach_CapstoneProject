import 'package:flutter/material.dart';
import '../../../../core/constants/ideal_shots.dart';
import '../../domain/entities/delivery.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final Delivery delivery;

  const DeliveryDetailsPage({Key? key, required this.delivery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String shotImage = shotImages[delivery.idealShot] ?? "assets/images/default_shot.png";
    final String shotInstruction = shotInstructions[delivery.idealShot] ?? "No specific instructions available.";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Speed: ${delivery.speed} km/h'),
            Text('Accuracy: ${delivery.accuracy}%'),
            Text('Right-Handed Batsman: ${delivery.rightHandedBatsman ? "Yes" : "No"}'),
            Text('Bounce Height: ${delivery.bounceHeight}'),
            Text('Ball Length: ${delivery.ballLength}'),
            Text('Horizontal Position: ${delivery.horizontalPosition}'),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  Text(
                    'Ideal Shot: ${delivery.idealShot}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Image.asset(
                    shotImage,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'How to Execute:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    shotInstruction,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}