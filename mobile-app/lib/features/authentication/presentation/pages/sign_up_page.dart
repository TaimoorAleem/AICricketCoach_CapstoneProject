import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:wqeqwewq/features/authentication/presentation/pages/log_in_page.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../user_profile/presentation/pages/edit_user_profile_page.dart';
import '../../data/models/signup_req_params.dart';
import '../../domain/usecases/signup_usecase.dart';


class SignupPage extends StatelessWidget {
  SignupPage({super.key});

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
            _signupText(),
            const SizedBox(height: 30,),
            _emailField(),
            const SizedBox(height: 20,),
            _passwordField(),
            const SizedBox(height: 60,),
            _signupButton(context),
            const SizedBox(height: 20,),
            _loginText(context)
          ],
        ),
      ),
    );
  }

  Widget _signupText() {
    return const Text(
      'Sign Up',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
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

  Widget _signupButton(BuildContext context) {
    return ReactiveButton(
        title: 'Sign Up',
        activeColor: AppColors.primary,
        onPressed: () async => sl < SignupUseCase > ().call(
          params: SignupReqParams(
              email: _emailCon.text,
              password: _passwordCon.text
          ),
        ),
        onSuccess: () {
          AppNavigator.pushAndRemove(context, EditUserProfilePage());
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        }
    );
  }

  Widget _loginText(BuildContext context) {
    return Text.rich(
        TextSpan(
            children: [
              const TextSpan(
                  text: "Do you have account?"
              ),
              TextSpan(
                  text: ' Log In',
                  style: const TextStyle(
                      color: Colors.blue
                  ),
                  recognizer: TapGestureRecognizer()..onTap=(){
                    AppNavigator.push(context, LogInPage());
                  }
              )
            ]
        )
    );
  }
}