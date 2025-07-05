import 'package:flutter/material.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/util.dart';
import 'package:plantcare_mobile/screens/profil/profil_lajk_screen.dart';
import 'package:plantcare_mobile/screens/profil/profil_omiljeni_post_screen.dart';
import 'package:plantcare_mobile/screens/profil/profil_post_screen.dart';
import 'package:plantcare_mobile/screens/profil/profile_details_screen.dart';
import 'package:plantcare_mobile/screens/profil/profile_edit_screen.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  ProfilScreenState createState() => ProfilScreenState();
}

class ProfilScreenState extends State<ProfilScreen> {
  @override
  void initState() {
    super.initState();
    loadProfil();
  }

  Future<void> loadProfil() async {}

  @override
  Widget build(BuildContext context) {
    final korisnik = AuthProvider.korisnik;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  "Profil",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: korisnik?.slika != null
                        ? imageFromString(korisnik!.slika!)
                        : const Icon(Icons.person, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '${korisnik?.ime ?? ''} ${korisnik?.prezime ?? ''}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileEditScreen(),
                      ),
                    );

                    if (!mounted) return;

                    if (result == true) {
                      setState(() {});
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50C878),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 36),
                  ),
                  child: const Text("Uredi profil"),
                ),
              ),
              const SizedBox(height: 32),

              _buildOptionCard("📄 Moji postovi", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilPostScreen()),
                );
              }),
              _buildOptionCard("❤️ Lajkovi", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilLajkoviPostScreen(),
                  ),
                );
              }),
              _buildOptionCard("⭐ Omiljeni", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfilOmiljeniPostScreen(),
                  ),
                );
              }),
              _buildOptionCard("ℹ️ Informacije", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileDetailScreen(),
                  ),
                );
              }),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: () => _confirmLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text("Odjavi se"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: onTap,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Odjava"),
        content: const Text("Da li ste sigurni da se želite odjaviti?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Odjavi se"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      AuthProvider.korisnik = null;
      AuthProvider.username = '';
      AuthProvider.password = '';
      NotificationListenerMobile.instance.resetUnreadCount();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}
