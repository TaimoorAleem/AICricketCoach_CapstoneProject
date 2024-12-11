import 'package:flutter/material.dart';
import '../../domain/entities/session.dart';
import '../pages/delivery_details_page.dart';

class SessionCard extends StatelessWidget {
  final Session session;

  const SessionCard({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('Session ID: ${session.sessionId}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average Speed: } km/h'),
            Text('Average Accuracy: %'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailsPage(delivery: session.deliveries.first),
            ),
          );
        },
      ),
    );
  }
}