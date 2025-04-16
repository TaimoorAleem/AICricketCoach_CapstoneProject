import 'package:flutter/material.dart';
import '../../../../resources/app_colors.dart';
import '../../domain/entities/session.dart';
import '../widgets/DeliveryCard.dart';

class SessionDetailsPage extends StatelessWidget {
  final Session session;
  final String playerId;

  const SessionDetailsPage({
    super.key,
    required this.session,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        title: Text(
          'Session Details',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session ID: ${session.sessionId}',
              style: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${session.date}',
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'Nunito',
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deliveries:',
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: session.deliveries.isEmpty
                  ? const Center(
                child: Text(
                  'No deliveries found.',
                  style: TextStyle(
                    color: Colors.white60,
                    fontFamily: 'Nunito',
                    fontSize: 14,
                  ),
                ),
              )
                  : ListView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
