import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../pages/session_details_page.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final String playerId;

  const SessionCard({super.key, required this.session, required this.playerId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text("Session ID: ${session.sessionId}"),
        subtitle: Text("Date: ${session.date}"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SessionDetailsPage(session: session, playerId: playerId),
            ),
          );
        },
      ),
    );
  }
}
