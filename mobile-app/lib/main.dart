import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../resources/service_locator.dart';
import 'features/analytics/presentation/bloc/AuthCubit.dart';
import 'features/authentication/presentation/pages/loading_page.dart';
import '../resources/app_theme.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
        )
    );
    return BlocProvider(
      create: (context) => AuthCubit()..appStarted(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          home: const LoadingPage()
      ),
    );
  }
}


