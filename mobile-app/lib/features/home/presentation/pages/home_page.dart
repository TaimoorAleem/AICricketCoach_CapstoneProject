import 'package:ai_cricket_coach/features/authentication/presentation/pages/log_in_page.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:ai_cricket_coach/resources/app_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';

import '../../../../resources/app_colors.dart';
import '../../../video_upload/presentation/pages/upload_video.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      _pageHeading(),
                      _profileButton(context),
                    ]))));
  }


  Widget _pageHeading() {
    return const Text(
      'Welcome to AI Cricket Coach! (Home Page)',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: AppColors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _profileButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          AppNavigator.pushAndRemove(context, UserProfilePage());
        },
        child: const Text("User Profile"),
      )
      ,
    );
  }

  Widget  _videoUploadButton(BuildContext context){
    return ElevatedButton(
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
    );
  }


}
