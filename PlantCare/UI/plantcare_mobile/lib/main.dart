import 'package:flutter/material.dart';
import 'package:plantcare_mobile/core/theme.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';
import 'package:plantcare_mobile/screens/auth/login_screen.dart';
import 'package:plantcare_mobile/screens/auth/register_screen.dart';
import 'package:plantcare_mobile/screens/auth/start_screen.dart';
import 'package:plantcare_mobile/screens/auth/stripe_payment_screen.dart';
import 'package:plantcare_mobile/screens/home/notifications_screen.dart';
import 'package:plantcare_mobile/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:plantcare_mobile/providers/filter_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:plantcare_mobile/.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await Stripe.instance.applySettings();
  await NotificationListenerMobile.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FilterProvider(),
      child: const PlantCareApp(),
    ),
  );
}

class PlantCareApp extends StatelessWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/start',
      routes: {
        '/start': (context) => const StartScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/stripe-payment': (context) => const StripePaymentScreen(),
      },
    );
  }
}
