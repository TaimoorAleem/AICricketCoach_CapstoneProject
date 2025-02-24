import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../widgets/DeliveryCard.dart';

class SessionDetailsPage extends StatelessWidget {
  final Session session;

  const SessionDetailsPage({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Details')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Date: ${session.date}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: session.deliveries.length,
              itemBuilder: (context, index) {
                final delivery = session.deliveries[index];
                return DeliveryCard(delivery: delivery);
              },
            ),
          ),
        ],
      ),
    );
  }
}
