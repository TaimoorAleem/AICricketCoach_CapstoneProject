import 'package:flutter/material.dart';

class SessionDetailsPage extends StatelessWidget {
  final String sessionId;

  const SessionDetailsPage({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session ID: $sessionId',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Details will go here...'),
          ],
        ),
      ),
    );
  }
}
