import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_cricket_coach/features/video_upload/presentation/pages/upload_video.dart';
import 'package:ai_cricket_coach/features/sessions/presentation/pages/delivery_details_page.dart';
import 'package:ai_cricket_coach/resources/api_urls.dart';
import 'package:ai_cricket_coach/resources/dio_client.dart';
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:ai_cricket_coach/features/home/presentation/widgets/session_manager.dart';
import '../../../sessions/domain/entities/session.dart';
import '../../../home/data/data_sources/session_cache.dart';

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
      final response = await dioClient.get(
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

        Navigator.pop(context);
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Active Session',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: AppColors.primary,
                ),
              ),
              backgroundColor: AppColors.secondary,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (activeSession == null)
              const Expanded(
                child: Center(
                  child: Text(
                    'No active session.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: activeSession!.deliveries.length,
                  itemBuilder: (context, index) {
                    final delivery = activeSession!.deliveries[index];
                    return Card(
                      color: AppColors.secondary,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        title: Text(
                          'Delivery ${index + 1}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Ball Speed: ${delivery.ballSpeed} km/h',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.white70,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.white),
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
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 24),
                      label: const Text(
                        'Add New Delivery',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadVideoPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.stop_circle_outlined, size: 24),
                      label: const Text(
                        'End Session',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: endSession,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
