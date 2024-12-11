import 'package:ai_cricket_coach/features/feedback/presentation/pages/ideal_shot_page.dart';
import 'package:flutter/material.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/service_locator.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';
import '../../../feedback/domain/usecases/predict_shot.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Button background color
                foregroundColor: Colors.white, // Button text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
              child: const Text('Go to User Profile'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Button background color
                foregroundColor: Colors.white, // Button text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionsHistoryPage(),
                  ),
                );
              },
              child: const Text('Go to Sessions History'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Button background color
                foregroundColor: Colors.white, // Button text color
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IdealShotPage(
                      predictShot: sl<PredictShot>(), // Inject the use case here
                    ),
                  ),
                );
              },
              child: const Text('Go to Feedback Page'),
            ),
          ],
        ),
      ),
    );
  }
}