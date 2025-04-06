import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/resources/session_cache.dart';
import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
import 'package:ai_cricket_coach/features/sessions/presentation/pages/delivery_details_page.dart';
import '../../../sessions/domain/entities/session.dart';

class SessionsManagerPage extends StatefulWidget {
  const SessionsManagerPage({Key? key}) : super(key: key);

  @override
  State<SessionsManagerPage> createState() => _SessionsManagerPageState();
}

class _SessionsManagerPageState extends State<SessionsManagerPage> {
  Session? activeSession;

  @override
  void initState() {
    super.initState();
    _loadActiveSession();
  }

  Future<void> _loadActiveSession() async {
    final session = await SessionCache().getActiveSession();
    setState(() {
      activeSession = session;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeSession == null
          ? const Center(child: Text('No active session.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: activeSession!.deliveries.length,
              itemBuilder: (context, index) {
                final delivery = activeSession!.deliveries[index];
                return ListTile(
                  title: Text('Delivery ${index + 1}'),
                  subtitle: Text('Ball Speed: ${delivery.ballSpeed}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryDetailsPage(
                          sessionId: activeSession!.sessionId,
                          deliveryId: delivery.deliveryId,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add New Delivery'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadVideoPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}