import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/service_locator.dart';
import '../../../coaches/domain/usecases/get_players_usecase.dart';
import '../../../coaches/presentation/pages/coach_home_page.dart';
import '../../../home/data/data_sources/session_cache.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/AuthCubit.dart';
import '../bloc/AuthState.dart';
import 'log_in_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) async {
          print("🔥 LoadingPage received state: $state");

          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, LogInPage());
          }

          if (state is Authenticated) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('uid', state.uid);
            SessionCache().setActivePlayerId(state.uid); // ✅
            AppNavigator.pushReplacement(context, const HomePage());
          }

          if (state is CoachAuthenticated) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('uid', state.uid);
            SessionCache().setActivePlayerId(state.uid); // ✅

            AppNavigator.pushReplacement(
              context,
              MultiProvider(
                providers: [
                  Provider<GetPlayersUseCase>(
                    create: (_) => sl<GetPlayersUseCase>(),
                  ),
                ],
                child: const CoachHomePage(),
              ),
            );
          }
        },
        child: Stack(
          children: [
            Container(color: AppColors.background),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/logo.png', height: 120, width: 120),
                  const SizedBox(height: 30),
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
