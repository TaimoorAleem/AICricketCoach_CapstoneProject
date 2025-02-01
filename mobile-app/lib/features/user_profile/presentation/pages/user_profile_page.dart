
import 'package:ai_cricket_coach/features/user_profile/presentation/widgets/user_profile.dart';

import 'package:flutter/material.dart';

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