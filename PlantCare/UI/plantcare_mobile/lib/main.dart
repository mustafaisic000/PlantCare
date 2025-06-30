import 'package:flutter/material.dart';
import 'package:plantcare_mobile/core/theme.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';
import 'package:plantcare_mobile/screens/auth/login_screen.dart';
import 'package:plantcare_mobile/screens/auth/register_screen.dart';
import 'package:plantcare_mobile/screens/auth/start_screen.dart';
import 'package:plantcare_mobile/screens/home/notifications_screen.dart';
import 'package:plantcare_mobile/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationListenerMobile.instance.init();
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
      initialRoute: '/login',
      routes: {
        '/start': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
