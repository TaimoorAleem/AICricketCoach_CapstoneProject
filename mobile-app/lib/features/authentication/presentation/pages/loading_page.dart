
import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/app_navigator.dart';
import '../../../authentication/presentation/bloc/AuthCubit.dart';
import '../../../authentication/presentation/bloc/AuthState.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'log_in_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit,AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, LogInPage());
          }

          if (state is Authenticated) {
            AppNavigator.pushReplacement(context, const HomePage());
          }
        },
        child: Stack(
          children: [
            // Background color
            Container(
              color: AppColors.background, // Replace with your desired background color
            ),
            // Centered content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'lib/images/logo.png', // Path to your logo
                    height: 120, // Adjust size as needed
                    width: 120,
                  ),
                  const SizedBox(height: 30),
                  // Rotating loading bar
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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