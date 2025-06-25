import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/bottom_navbar.dart';
import 'package:plantcare_mobile/screens/home/home_screen.dart';
import 'package:plantcare_mobile/screens/kategorije/kategorije_screen.dart';
import 'package:plantcare_mobile/screens/dodaj/dodaj_screen.dart';
import 'package:plantcare_mobile/screens/profil/profil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    KategorijeScreen(),
    DodajScreen(),
    ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
