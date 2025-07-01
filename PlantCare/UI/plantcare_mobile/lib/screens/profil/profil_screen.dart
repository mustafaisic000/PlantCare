import 'package:flutter/material.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/util.dart';
import 'package:plantcare_mobile/screens/profil/profil_lajk_screen.dart';
import 'package:plantcare_mobile/screens/profil/profil_omiljeni_post_screen.dart';
import 'package:plantcare_mobile/screens/profil/profil_post_screen.dart';
import 'package:plantcare_mobile/screens/profil/profile_details_screen.dart';
import 'package:plantcare_mobile/screens/profil/profile_edit_screen.dart';

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

  Future<void> loadProfil() async {
    // Kasnije dohvat korisnika ako treba
  }

  @override
  Widget build(BuildContext context) {
    final korisnik = AuthProvider.korisnik;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Profil",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
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
              Text(
                '${korisnik?.ime ?? ''} ${korisnik?.prezime ?? ''}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileEditScreen(),
                    ),
                  );

                  if (result == true) {
                    setState(() {}); // Trigger rebuild
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF50C878),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 36),
                ),
                child: const Text("Edit"),
              ),
              const SizedBox(height: 32),
              _buildOption("Postovi"),
              _buildOption("Likes"),
              _buildOption("Omiljeni"),
              _buildOption("Informacije"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String title) {
    return InkWell(
      onTap: () {
        switch (title) {
          case "Postovi":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilPostScreen()),
            );
            break;
          case "Likes":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilLajkoviPostScreen(),
              ),
            );
            break;
          case "Omiljeni":
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfilOmiljeniPostScreen(),
              ),
            );
            break;
          case "Informacije":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileDetailScreen()),
            );
            break;
        }
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [Text(title, style: const TextStyle(fontSize: 16))],
        ),
      ),
    );
  }
}
