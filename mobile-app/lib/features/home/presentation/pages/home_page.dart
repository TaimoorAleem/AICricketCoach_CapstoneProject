import 'package:ai_cricket_coach/features/feedback/presentation/pages/ideal_shot_page.dart';
import 'package:flutter/material.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/service_locator.dart';
import '../../../sessions/presentation/pages/sessions_history_page.dart';
import '../../../user_profile/presentation/pages/user_profile_page.dart';
import '../../../feedback/domain/usecases/predict_shot.dart';
import '../../../video_upload/presentation/pages/video_capture_page.dart';
import '../../../video_upload/presentation/pages/upload_video.dart';
import '../../../video_upload/domain/usecases/captureVideoUseCase.dart';
import 'package:camera/camera.dart';

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
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoCapturePage(),
                  ),
                );
              },
              child: const Text('Capture Video'),
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
                    builder: (context) => const SessionsHistoryPage(),
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
                      predictShot: sl<PredictShot>(),
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


// const SizedBox(height: 20),
// // Capture Video Button
// ElevatedButton(
//   style: ElevatedButton.styleFrom(
//     backgroundColor: AppColors.primary,
//     foregroundColor: Colors.white,
//   ),
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const VideoCapturePage(),
//       ),
//     );
//   },
//   child: const Text('Capture Video'),
// ),