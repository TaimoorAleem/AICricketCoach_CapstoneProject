import 'package:flutter/material.dart';
import 'package:ai_cricket_coach/features/analytics/presentation/pages/analytics_page.dart';
import 'package:ai_cricket_coach/features/feedback/presentation/pages/ideal_shot_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/service_locator.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';
import '../../../feedback/domain/usecases/predict_shot_usecase.dart';

import '../../../video_upload/presentation/pages/upload_video.dart';

import 'package:camera/camera.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<String?> _getPlayerUid() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.secondary,
      ),
      body: FutureBuilder<String?>(
        future: _getPlayerUid(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final playerUid = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()),
                    );
                  },
                  child: const Text('Go to User Profile'),
                ),
                const SizedBox(height: 20),
                // New Upload Video Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadVideoPage(),
                      ),
                    );
                  },
                  child: const Text('Upload Video'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionsHistoryPage(playerUid: playerUid),
                      ),
                    );
                  },
                  child: const Text('Go to Sessions History'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdealShotPage(
                          predictShot: sl<PredictShotUseCase>(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Go to Feedback Page'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsPage.singlePlayer(playerUid: playerUid)),
                    );
                  },
                  child: const Text('Go to Analytics Page'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}