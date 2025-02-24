import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../resources/service_locator.dart';
import 'features/authentication/presentation/bloc/AuthCubit.dart';
import 'features/coaches/domain/usecases/get_players_usecase.dart';
import 'features/coaches/presentation/bloc/PlayerCubit.dart';
import 'features/authentication/presentation/pages/loading_page.dart';
import '../resources/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GetPlayersUseCase>(create: (_) => sl<GetPlayersUseCase>()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()..appStarted()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const LoadingPage(),
      ),
    );
  }
}
