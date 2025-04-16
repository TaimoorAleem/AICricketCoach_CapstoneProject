import 'dart:async';
import 'dart:math';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ai_cricket_coach/features/authentication/presentation/bloc/AuthCubit.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'resources/service_locator.dart';
import 'features/authentication/presentation/pages/loading_page.dart';
import 'resources/app_colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await requestNotifPermissions();

  NotifService notifService = NotifService();
  await notifService.initLocalNotifFirebase();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    notifService.showNotifBanner(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setAutoInitEnabled(false);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  await setupServiceLocator();

  runApp(const MyApp());
}

Future<void> requestNotifPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint("User granted permissions");
  } else {
    debugPrint("User denied permissions");
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Background message received: ${message.messageId}");
  NotifService notifService = NotifService();
  notifService.showNotifBanner(message);
}

class NotifService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifFirebase() async {
    var androidInit = const AndroidInitializationSettings('@drawable/logo');
    var initSetting = InitializationSettings(android: androidInit);
    await _flutterLocalNotificationsPlugin.initialize(initSetting,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification tapped! Payload: ${response.payload}');
        });
  }

  Future<void> showNotifBanner(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin.show(
      Random.secure().nextInt(10000),
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      NotificationDetails(android: androidDetails),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return BlocProvider(
      create: (_) => AuthCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.secondary,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
          ),
        ),
        home: const LoadingPage(),
      ),
    );
  }
}
