import 'package:flutter/material.dart';
import '../../../../resources/app_colors.dart';
import '../../domain/entities/session.dart';
import '../pages/session_details_page.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final String playerId;
  final int sessionNumber;

  const SessionCard({
    super.key,
    required this.session,
    required this.playerId,
    required this.sessionNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: Text(
          "Session #$sessionNumber",
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(
          "Date: ${session.date}",
          style: const TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
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
