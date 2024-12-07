import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:wqeqwewq/features/authentication/domain/usecases/login_usecase.dart';
import 'package:wqeqwewq/features/authentication/presentation/pages/sign_up_page.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../data/models/login_req_params.dart';

class LogInPage extends StatelessWidget {
  LogInPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 100,right:16,left:16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _loginText(),
            const SizedBox(height: 30,),
            _emailField(),
            const SizedBox(height: 20,),
            _passwordField(),
            const SizedBox(height: 60,),
            _loginButton(context),
            const SizedBox(height: 20,),
            _signupText(context)
          ],
        ),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Log In',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon ,
      decoration: const InputDecoration(
          hintText: 'Email'
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(
          hintText: 'Password'
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return ReactiveButton(
      title: 'Sign In',
      activeColor: AppColors.primary,
      onPressed: () async => sl<LoginUseCase>().call(
          params: LoginReqParams(
              email: _emailCon.text,
              password: _passwordCon.text
          )
      ),
      onSuccess: () {
        AppNavigator.pushAndRemove(context, const HomePage());
      },
      onFailure: (error) {
        DisplayMessage.errorMessage(error, context);
      },
    );
  }

  Widget _signupText(BuildContext context) {
    return Text.rich(
        TextSpan(
            children: [
              const TextSpan(
                  text: "Don't you have account?"
              ),
              TextSpan(
                  text: ' Sign Up',
                  style: const TextStyle(
                      color: Colors.blue
                  ),
                  recognizer: TapGestureRecognizer()..onTap=(){
                    AppNavigator.push(context, SignupPage());
                  }
              )
            ]
        )
    );
  }
}

