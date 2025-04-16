import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../authentication/domain/usecases/login_usecase.dart';
import '../../../authentication/data/models/login_req_params.dart';
import '../../../authentication/presentation/bloc/AuthCubit.dart';
import '../../../authentication/presentation/pages/loading_page.dart';
import 'sign_up_page.dart';
import 'reset_password_page.dart';

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
            children: [
              const SizedBox(height: 100),
              Image.asset('lib/images/logo.png', height: 120, width: 120),
              const SizedBox(height: 20),
              const Text('AI Cricket Coach', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.primary)),
              const SizedBox(height: 20),
              _loginFields(context),
              const SizedBox(height: 16),
              _signupText(context),
              _forgotPasswordText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginFields(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailCon,
          decoration: _inputDecoration('Email'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordCon,
          obscureText: true,
          decoration: _inputDecoration('Password'),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () async {
            final result = await sl<LoginUseCase>().call(
              params: LoginReqParams(email: _emailCon.text, password: _passwordCon.text),
            );
            result.fold(
                  (failure) => DisplayMessage.errorMessage(failure.toString(), context),
                  (_) async {
                final prefs = await SharedPreferences.getInstance();
                final uid = prefs.getString('uid');
                final role = prefs.getString('role');
                if (uid != null) {
                  SessionCache().setActivePlayerId(uid);
                  context.read<AuthCubit>().authenticate(uid: uid, role: role);
                  AppNavigator.pushAndRemove(context, const LoadingPage());
                }
              },
            );
          },
          child: const Text('Sign In'),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.secondary,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _signupText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Don't have an account? ",
        children: [
          TextSpan(
            text: 'Sign Up',
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.push(context, SignupPage()),
          ),
        ],
      ),
    );
  }

  Widget _forgotPasswordText(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Forgot Password?',
        style: const TextStyle(color: Colors.blue),
        recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.push(context, ResetPasswordPage()),
      ),
    );
  }
}
