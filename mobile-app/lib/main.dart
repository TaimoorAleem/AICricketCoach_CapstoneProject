import 'package:flutter/material.dart';
import 'features/feedback/presentation/pages/accuracy_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accuracy Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AccuracyPage(),
    );
  }
}
