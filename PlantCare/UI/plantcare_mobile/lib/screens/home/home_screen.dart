import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Sve";

  void handleFilterChange(String value) {
    setState(() => selectedFilter = value);
  }

  void openNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: HomeHeader(
              onNotificationsTap: openNotifications,
              onFilterSelected: handleFilterChange,
            ),
          ),
        ],
      ),
    );
  }
}
