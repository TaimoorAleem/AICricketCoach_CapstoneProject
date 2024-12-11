import 'package:flutter/material.dart';
import 'package:ai_cricket_coach/features/sessions/domain/entities/session.dart';

import '../widgets/DeliveryCard.dart';

class SessionDetailsPage extends StatelessWidget {
  final Session session;

  const SessionDetailsPage({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session Details Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session Date: ${session.date}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Average Speed: 0 km/h'),
                Text('Average Accuracy: 0%'),
                Text('Execution Rating: 0'),
              ],
            ),
          ),
          Divider(),

          // List of Deliveries
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
