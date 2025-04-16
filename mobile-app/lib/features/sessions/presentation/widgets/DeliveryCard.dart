import 'package:flutter/material.dart';
import '../../../../resources/app_colors.dart';
import '../../domain/entities/delivery.dart';
import '../pages/delivery_details_page.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final String sessionId;
  final String playerId;

  const DeliveryCard({
    super.key,
    required this.delivery,
    required this.sessionId,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          "Delivery",
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Speed: ${delivery.ballSpeed} km/h", style: _subtitleStyle),
            Text("Line: ${delivery.ballLine}", style: _subtitleStyle),
            Text("Length: ${delivery.ballLength}", style: _subtitleStyle),
            Text("Batsman Position: ${delivery.batsmanPosition == 0 ? 'Left' : 'Right'}", style: _subtitleStyle),
            if (delivery.feedback != null)
              Text("Feedback: ${delivery.feedback}", style: _subtitleStyle),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
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

  TextStyle get _subtitleStyle => const TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    color: Colors.white70,
  );
}
