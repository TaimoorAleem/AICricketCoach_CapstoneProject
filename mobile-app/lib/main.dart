import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../resources/service_locator.dart';
import 'features/authentication/presentation/bloc/AuthCubit.dart';
import 'features/coaches/domain/usecases/get_players_usecase.dart';
import 'features/authentication/presentation/pages/loading_page.dart';
import '../resources/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await requestNotifPermissions();
  setupServiceLocator();

  runApp(const MyApp());
}

/// 📩 Background message handler (Ensuring it's not duplicated)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("📩 Background message received: ${message.messageId}");
}

/// 📲 Request notification permissions
Future<void> requestNotifPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint(settings.authorizationStatus == AuthorizationStatus.authorized
      ? "🔔 User granted permissions for notifications."
      : "🚫 User denied notification permissions.");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GetPlayersUseCase>(create: (_) => sl<GetPlayersUseCase>()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..appStarted()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const LoadingPage(),
      ),
    );
  }
}
