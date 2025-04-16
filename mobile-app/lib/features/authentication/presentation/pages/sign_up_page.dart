import 'package:ai_cricket_coach/features/user_profile/data/models/role_enum.dart';
import 'package:ai_cricket_coach/features/user_profile/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../user_profile/presentation/pages/edit_user_profile_page.dart';
import '../../data/models/signup_req_params.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'log_in_page.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}
class _SignUpPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  late bool _isFormValid;

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  late Role _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = Role.player;
    _isFormValid = false;
  }

  @override
  void dispose() {
    _emailCon.dispose();
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'lib/images/logo.png', // Path to your logo
              height: 90, // Adjust size as needed
              width: 90,
            ),
            const SizedBox(height: 15),
            _welcomeHeading(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _signupContainer(context),
                        const SizedBox(height: 10),
                        _loginText(context),
                      ],
                    ),
                  )
                ),
              ),
            ),
          ],
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
        fontSize: 24,
        color: AppColors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _signupContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _names(),
          const SizedBox(height: 22),
          _emailField(),
          const SizedBox(height: 22),
          _passwordField(),
          const SizedBox(height: 22),
          _rolePickField(context),
          const SizedBox(height: 15),
          _validateAndSignUp(context)
        ],
      ),
    );
  }

  Widget _names() {
    return Row(
      children: [
        Expanded(child: _firstNameField()),
        SizedBox(width: 10),
        Expanded(child: _lastNameField())
      ],
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
  Widget _firstNameField() {
    return TextFormField(
      controller: _firstNameCon,
      style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
      decoration: InputDecoration(
        hintText: 'First Name',
        hintStyle: const TextStyle(color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,),
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
      onChanged: (_){
        setState(() {
          _isFormValid = false; // Show tick icon after successful validation
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;  // Return null if the input is valid
      },
    );
  }
  Widget _lastNameField() {
    return TextFormField(
      controller: _lastNameCon,
      style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
      decoration: InputDecoration(
        hintText: 'LastName',
        hintStyle: const TextStyle(color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,),
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
      onChanged: (_){
        setState(() {
          _isFormValid = false; // Show tick icon after successful validation
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;  // Return null if the input is valid
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailCon,
      style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,),
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
      onChanged: (_){
        setState(() {
          _isFormValid = false; // Show tick icon after successful validation
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;  // Return null if the input is valid
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordCon,
      obscureText: true,
      style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: const TextStyle(color: AppColors.primary,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w500,),
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
      onChanged: (_){
        setState(() {
          _isFormValid = false; // Show tick icon after successful validation
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        // Regex to check for at least one uppercase, one numeric, and one special character
        RegExp passwordRegExp = RegExp(
          r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[\W_]).{6,}$',
        );
        if (!passwordRegExp.hasMatch(value)) {
          return 'Password must contain at least one uppercase letter, one number, and one special character';
        }
        return null;
      },
    );
  }

  Widget _validateButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.check, // The tick icon
          color: _isFormValid
              ? AppColors.primary
              : Colors.grey,
        ),
        onPressed: () {
          if (!_isFormValid) {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isFormValid = true; // Show tick icon after successful validation
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Form is valid!")),
              );
            }
          }
        });
  }
  
  Widget _validateAndSignUp(BuildContext context){
    return Row(
      children: [
        if (!_isFormValid) ...[
          _validateButton(context),
        ],
        if (_isFormValid) ...[
          _signupButton(context)
        ]
      ],
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
              firstName: _firstNameCon.text,
              lastName: _lastNameCon.text,
              email: _emailCon.text,
              password: _passwordCon.text,
              role: _selectedRole.title),
        ),
        onSuccess: () async {
          SharedPreferences sharedPreferences =  await SharedPreferences.getInstance();
          var _uid = sharedPreferences.getString('uid');
          var _firstName = sharedPreferences.getString('firstName');
          var _lastName = sharedPreferences.getString('lastName');
          var _role = sharedPreferences.getString('role');

          AppNavigator.pushAndRemove(
              context,
              EditUserProfilePage(
                user: UserEntity(
                    age: "",
                    city: "",
                    country: "",
                    description: "",
                    email: "",
                    firstName: _firstName ?? "NA",
                    lastName: _lastName ?? "NA",
                    pfpUrl: "NA",
                    role: _role ?? "NA",
                    teamName: "",
                    uid: _uid ?? ""), pfpPath: '',));
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
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: 'Log In',
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.blue,
              fontWeight: FontWeight.w500,
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
        style: const TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        decoration: InputDecoration(
          label: Text('Role'),
          labelStyle: TextStyle(color: AppColors.primary),  // Label text color
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
        dropdownColor: AppColors.secondary,
      ),
    );
  }



}