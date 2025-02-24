import 'package:ai_cricket_coach/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../resources/app_navigator.dart';
import '../../../../resources/service_locator.dart';
import '../../../authentication/presentation/bloc/AuthCubit.dart';
import '../../../authentication/presentation/bloc/AuthState.dart';
import '../../../coaches/domain/usecases/get_players_usecase.dart';
import '../../../coaches/presentation/bloc/PlayerCubit.dart';
import '../../../coaches/presentation/pages/coach_home_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'log_in_page.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, LogInPage());
          }

          if (state is Authenticated) {
            AppNavigator.pushReplacement(context, const HomePage());
          }

          if (state is CoachAuthenticated) {
            AppNavigator.pushReplacement(
              context,
              MultiProvider(
                providers: [
                  Provider<GetPlayersUseCase>(create: (_) => sl<GetPlayersUseCase>()),
                  BlocProvider<PlayerCubit>(
                    create: (context) => PlayerCubit(getPlayersUseCase: context.read<GetPlayersUseCase>()),
                  ),
                ],
                child: CoachHomePage(coachUid: state.uid),
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
