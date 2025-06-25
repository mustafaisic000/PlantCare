import 'package:flutter/material.dart';
import 'package:plantcare_mobile/core/theme.dart';
import 'package:plantcare_mobile/screens/auth/start_screen.dart';
import 'package:plantcare_mobile/screens/home/notifications_screen.dart';

void main() {
  runApp(const PlantCareApp());
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const StartScreen(),
      routes: {'/notifications': (context) => const NotificationsScreen()},
    );
  }
}
