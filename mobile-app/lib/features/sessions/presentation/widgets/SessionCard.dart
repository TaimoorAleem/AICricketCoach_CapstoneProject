import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../pages/session_details_page.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final String playerId; // ✅ Added playerId to track which player this session belongs to

  const SessionCard({Key? key, required this.session, required this.playerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Session ID: ${session.sessionId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average Speed: ${session.deliveries.isNotEmpty ? session.deliveries.map((e) => e.speed).reduce((a, b) => a + b) / session.deliveries.length : 'N/A'} km/h'),
            Text('Average Accuracy: ${session.deliveries.isNotEmpty ? session.deliveries.map((e) => e.accuracy).reduce((a, b) => a + b) / session.deliveries.length : 'N/A'} %'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigating to SessionDetailsPage while passing playerId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailsPage(
                session: session,
                playerId: playerId, // ✅ Ensure playerId is passed
              ),
            ),
          );
        },
      ),
    );
  }
}
