import 'package:ai_cricket_coach/features/authentication/data/models/reset_pw_params.dart';
import 'package:ai_cricket_coach/features/authentication/domain/usecases/send_code_usecase.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import 'log_in_page.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({super.key});

  final TextEditingController _emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _backBar(context),
              const SizedBox(height: 100),
              Image.asset(
                'lib/images/logo.png', // Path to your logo
                height: 120, // Adjust size as needed
                width: 120,
              ),
              const SizedBox(height: 20),
              _welcomeHeading(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              _loginContainer(context),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeHeading() {
    return const Text(
      'AI Cricket Coach',
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w600,
        fontSize: 26,
        color: AppColors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _loginContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loginText(),
          const SizedBox(height: 20),
          _emailField(),
          const SizedBox(height: 20),
          const SizedBox(height: 5),
          _loginButton(context),
        ],
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Forgot your password? Enter your email address to receive your password reset information.',
      style: TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w500,
        fontSize: 15,
        color: Colors.white,
      ),
    );
  }
  Widget _backBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Replace with your actual home navigation logic
          AppNavigator.pushAndRemove(context, LogInPage());
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(
            fontFamily: 'Nunito',
            color: AppColors.primary,
            fontWeight: FontWeight.w500),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }


  Widget _loginButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Reset Password',
        width: 10,
        height: 30,
        activeColor: AppColors.primary,
        onPressed: () async => sl<SendCodeUseCase>().call(
          params: ResetPWParams(
            email: _emailCon.text,
          ),
          ),
        onSuccess: () {
          AppNavigator.pushAndRemove(context, LogInPage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }

}
