import 'package:ai_cricket_coach/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/presentation/pages/vid_display.dart';
import '../../data/models/login_req_params.dart';
import '../../domain/usecases/login_usecase.dart';
import 'reset_password_page.dart';
import 'sign_up_page.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset(
                'lib/images/logo.png', // Path to your logo
                height: 120, // Adjust size as needed
                width: 120,
              ),
              const SizedBox(height: 20),
              _welcomeHeading(),
              const SizedBox(height: 20),
              _loginContainer(context),
              const SizedBox(height: 20),
              _signupText(context),
              _forgotpwtext(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeHeading() {
    return const Text(
      'Welcome Back!',
      style: TextStyle(
        fontFamily: 'Nunito',
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const SizedBox(height: 5),
          _emailField(),
          const SizedBox(height: 20),
          const SizedBox(height: 5),
          _passwordField(),
          const SizedBox(height: 30),
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
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(
            fontFamily: 'Nunito',
            color: AppColors.primary,
            fontWeight: FontWeight.w900),
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

  Widget _passwordField() {
    return TextField(
      controller: _passwordCon,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(
            fontFamily: 'Nunito',
            color: AppColors.primary,
            fontWeight: FontWeight.w900),
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Make sure all fields match
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }


  Widget _loginButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Sign In',
        width: 10,
        height: 30,
        activeColor: AppColors.primary,
        onPressed: () async => await sl<LoginUseCase>().call(
            params: LoginReqParams(
              email: _emailCon.text,
              password: _passwordCon.text,
            ),
          ),

        onSuccess: () async {

          AppNavigator.pushAndRemove(context, UserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }

  Widget _forgotpwtext(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "",
          ),
          TextSpan(
            text: 'Forgot Password?',
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, ResetPasswordPage());
              },
          ),
        ],
      ),
    );
  }




  Widget _signupText(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: "Don't have an account? ",
            style: const TextStyle(fontFamily: 'Nunito',fontWeight: FontWeight.w900)
          ),
          TextSpan(
            text: 'Sign Up',
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.blue,
              fontWeight: FontWeight.w900,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, SignupPage());
              },
          ),
        ],
      ),
    );
  }
}
