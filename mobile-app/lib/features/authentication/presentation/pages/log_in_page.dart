import 'package:ai_cricket_coach/features/coaches/presentation/pages/coach_home_page.dart';
import 'package:ai_cricket_coach/features/home/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/display_message.dart';
import '../../../../resources/service_locator.dart';
import '../../../coaches/domain/usecases/get_players_usecase.dart';
import '../../../coaches/presentation/bloc/PlayerCubit.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../data/models/login_req_params.dart';

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
              const SizedBox(height: 50),
              _welcomeHeading(),
              const SizedBox(height: 20),
              _loginContainer(context),
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
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _loginContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _emailField(),
          const SizedBox(height: 20),
          _passwordField(),
          const SizedBox(height: 30),
          _loginButton(context),
        ],
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
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Center(
      child: ReactiveButton(
        title: 'Sign In',
        width: 10,
        height: 30,
        onPressed: () async {
          final result = await sl<LoginUseCase>().call(
            params: LoginReqParams(
              email: _emailCon.text,
              password: _passwordCon.text,
            ),
          );

          result.fold(
                (error) {
              print("❌ Login Failed: $error");
              DisplayMessage.errorMessage(error, context);
            },
                (data) async {
              await _redirectUser(context);
            },
          );
        },
        onSuccess: () async {
          await _redirectUser(context);
        },
        onFailure: (error) {
          DisplayMessage.errorMessage(error, context);
        },
      ),
    );
  }

  Future<void> _redirectUser(BuildContext context) async { // TODO: weird error message on home page after logging in
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? role = sharedPreferences.getString('role');
    final String? uid = sharedPreferences.getString('uid');

    if (role == "coach") {
      print("🔹 Navigating to CoachHomePage...");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider<GetPlayersUseCase>(create: (_) => sl<GetPlayersUseCase>()),
              BlocProvider<PlayerCubit>(
                create: (context) => PlayerCubit(getPlayersUseCase: context.read<GetPlayersUseCase>()),
              ),
            ],
            child: CoachHomePage(coachUid: uid!),
          ),
        ),
            (route) => false, // Clears the navigation stack
      );

      print("✅ Navigation to CoachHomePage completed");
    } else {
      print("🔹 Navigating to HomePage...");
      AppNavigator.pushAndRemove(context, const HomePage());
      print("✅ Navigation to HomePage completed");
    }
  }

}
