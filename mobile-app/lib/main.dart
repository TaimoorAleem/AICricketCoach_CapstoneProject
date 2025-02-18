import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await requestNotifPermissions();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Disable auto-init to prevent auto token refresh
  await messaging.setAutoInitEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  setupServiceLocator();
  runApp(const MyApp());
}
Future<void> requestNotifPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if(settings.authorizationStatus == AuthorizationStatus.authorized){
    debugPrint("User granted permissions");
  }
  else{
    debugPrint("User denied permissions");
  }
}


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message received: ${message.messageId}");
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

