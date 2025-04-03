import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';

import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/data/models/role_enum.dart';
import '../../../user_profile/domain/entities/user_entity.dart';
import '../../../user_profile/presentation/pages/edit_user_profile_page.dart';
import '../../data/models/signup_req_params.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'log_in_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  Role _selectedRole = Role.player;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Nunito', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Nunito', fontSize: 14),
          displayLarge: TextStyle(fontFamily: 'Nunito', fontSize: 22, fontWeight: FontWeight.bold),
          // Add other text styles as needed
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 70),
              Image.asset(
                'lib/images/logo.png', // Path to your logo
                height: 120, // Adjust size as needed
                width: 120,
              ),
              const SizedBox(height: 20),
              _welcomeHeading(),
              const SizedBox(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _signupContainer(context),
                        const SizedBox(height: 30),
                        _loginText(context),
                      ],
                    ),
                  ),
                ),
              ),
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
          const SizedBox(height: 20),
          _rolePickField(context),
          const SizedBox(height: 20),
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2), // Optional focus border
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
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // Removes border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2), // Optional focus border
        ),
      ),
    );
  }

  Widget _signupButton(BuildContext context) {
    String uid;
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
              role: _selectedRole.title),
        ),
        onSuccess: () {
          AppNavigator.pushAndRemove(
              context,
              EditUserProfilePage(
                user: UserEntity(
                    age: "age",
                    city: "city",
                    country: "country",
                    description: "description",
                    email: "email",
                    firstName: "firstName",
                    lastName: "lastName",
                    pfpUrl: "pfpUrl",
                    role: "role",
                    teamName: "teamName",
                    uid: ""), pfpPath: '',));
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
            text: "Already have an account? ",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900
            ),
          ),
          TextSpan(
            text: 'Log In',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w900,
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

  Widget _rolePickField(BuildContext context) {
    return Center(
      child: DropdownButtonFormField(
        value: _selectedRole,
        decoration: InputDecoration(
          label: Text('Role'),
          labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),  // Label text color
          filled: true,
          fillColor: AppColors.secondary,  // Background color for the field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),  // Rounded corners
            borderSide: BorderSide.none,  // No border by default
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,  // No border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),  // Focused border color
          ),
        ),
        items: Role.values.map((r) {
          return DropdownMenuItem(value: r, child: Text(r.title));
        }).toList(),
        onChanged: (value) {
          _selectedRole = value!;
        },
        dropdownColor: AppColors.secondary,  // Dropdown background color
        style: TextStyle(color: AppColors.primary),  // Text color of the dropdown
      ),
    );
  }

}

