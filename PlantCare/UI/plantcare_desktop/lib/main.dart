import 'package:flutter/material.dart';
import 'package:plantcare_desktop/core/theme.dart';
import 'package:plantcare_desktop/features/auth/login_screen.dart';
import 'package:plantcare_desktop/features/workspace/workspace_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare Admin',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) =>
            const WorkspaceScreen(), // ✅ Centralni ekran za sve sekcije
      },
    );
  }
}
