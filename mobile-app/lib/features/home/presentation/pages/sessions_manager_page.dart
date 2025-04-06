import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
import 'package:ai_cricket_coach/features/sessions/presentation/pages/delivery_details_page.dart';
import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:ai_cricket_coach/resources/dio_client.dart';
import 'package:ai_cricket_coach/features/home/presentation/widgets/session_manager.dart';
import '../../../sessions/domain/entities/session.dart';
import '../../data/data_sources/session_cache.dart';

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
    final session = SessionCache().getActiveSession();
    setState(() {
      activeSession = session;
    });
  }

  Future<void> endSession() async {
    final sessionId = SessionCache().activeSessionId;
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');

    if (sessionId == null || uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active session to end.')),
      );
      return;
    }

    try {
      final dioClient = await DioClient.init();
      final response = await dioClient.get( // this line exception thrown
        ApiUrl.getPerformance,
        queryParameters: {
          'uid': uid,
          'sessionId': sessionId,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        await SessionManager.clearActiveSession();
        SessionCache().clearActiveSession();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session ended and performance saved.')),
        );

        setState(() => activeSession = null);
      } else {
        throw Exception('Failed to end session: ${response.data}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
            child: Column(
              children: [
                ElevatedButton.icon(
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
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('End Session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: endSession,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}