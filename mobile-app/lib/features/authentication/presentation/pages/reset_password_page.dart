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
              const SizedBox(height: 50),
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
      'Welcome to AI Cricket Coach',
      style: TextStyle(
        fontWeight: FontWeight.bold,
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
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _loginText(),

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
      'Log In',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: AppColors.primary,
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(),
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
