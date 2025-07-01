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

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<KategorijeScreenState> _kategorijeKey =
      GlobalKey<KategorijeScreenState>();
  final GlobalKey<DodajPostScreenState> _dodajKey =
      GlobalKey<DodajPostScreenState>();
  final GlobalKey<ProfilScreenState> _profilKey =
      GlobalKey<ProfilScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(key: _homeKey),
          KategorijeScreen(key: _kategorijeKey),
          DodajPostScreen(key: _dodajKey),
          ProfilScreen(key: _profilKey),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            _homeKey.currentState?.loadData();
          }
          if (index == 1) _kategorijeKey.currentState?.loadKategorije();
          if (index == 2) _dodajKey.currentState?.loadDropdowns();
          if (index == 3) _profilKey.currentState?.loadProfil();
        },
      ),
    );
  }
}
