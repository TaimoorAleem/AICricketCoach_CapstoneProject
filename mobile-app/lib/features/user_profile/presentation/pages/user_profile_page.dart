import 'package:ai_cricket_coach/features/user_profile/domain/usecases/edit_profile.dart';
import 'package:ai_cricket_coach/features/user_profile/presentation/widgets/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../data/models/EditProfileReqParams.dart';

class UserProfilePage extends StatelessWidget{
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            UserProfile(),
          ],
        )
      )
    );

  }
}