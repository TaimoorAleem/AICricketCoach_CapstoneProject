import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/presentation/pages/edit_user_profile_page.dart';
import '../../data/models/signup_req_params.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'log_in_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              _welcomeHeading(),
              const SizedBox(height: 50),
              const SizedBox(height: 20),
              _signupContainer(context),
              const SizedBox(height: 20),
              _loginText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeHeading() {
    return const Text(
      'Welcome to AI Cricket Coach!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: AppColors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _signupContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _signupText(),
          const SizedBox(height: 20),
          _fieldLabel('Email'),
          const SizedBox(height: 5),
          _emailField(),
          const SizedBox(height: 20),
          _fieldLabel('Password'),
          const SizedBox(height: 5),
          _passwordField(),
          const SizedBox(height: 30),
          _signupButton(context),
        ],
      ),
    );
  }

  Widget _signupText() {
    return const Text(
      'Sign Up',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: AppColors.primary,
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
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

  Widget _passwordField() {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _signupButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Sign Up',
        width: 10,
        height: 30,
        activeColor: AppColors.primary,
        onPressed: () async => sl<SignupUseCase>().call(
          params: SignupReqParams(
            email: _emailCon.text,
            password: _passwordCon.text,
          ),
        ),
        onSuccess: () {
          AppNavigator.pushAndRemove(context, const UserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }

  Widget _loginText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Do you have an account? ",
          ),
          TextSpan(
            text: 'Log In',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, LogInPage());
              },
          ),
        ],
      ),
    );
  }
}
