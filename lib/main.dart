import 'package:dream_pos/layout/app_shell.dart';
import 'package:dream_pos/screens/onBoarding/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dreem POS',
      home: const SplashScreen(nextScreen: AppShell()),
    );
  }
}
