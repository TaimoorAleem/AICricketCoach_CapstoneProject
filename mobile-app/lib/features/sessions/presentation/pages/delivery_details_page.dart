import 'package:flutter/material.dart';
import '../../domain/entities/delivery.dart';
import '../../../../core/constants/ideal_shots.dart';
import '../../../feedback/presentation/pages/ideal_shot_page.dart';
import '../../../../resources/service_locator.dart';
import '../../../feedback/domain/usecases/predict_shot_usecase.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final Delivery delivery;

  const DeliveryDetailsPage({Key? key, required this.delivery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text('Speed: ${delivery.speed} km/h'),
            Text('Right-Handed Batsman: ${delivery.rightHandedBatsman ? "Yes" : "No"}'),
            Text('Bounce Height: ${delivery.bounceHeight}'),
            Text('Ball Length: ${delivery.ballLength}'),
            Text('Horizontal Position: ${delivery.horizontalPosition}'),

            const SizedBox(height: 20),

            // 📌 Navigate to IdealShotPage Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IdealShotPage(
                        predictShot: sl<PredictShotUseCase>(), // Injecting via service locator
                      ),
                    ),
                  );
                },
                child: const Text('View Ideal Shot Recommendation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
