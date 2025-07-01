import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/korisnici_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';
import 'package:plantcare_mobile/providers/util.dart'; // imageFromString

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  Korisnik? korisnik;
  final _provider = KorisnikProvider();

  @override
  void initState() {
    super.initState();
    _loadKorisnik();
  }

  Future<void> _loadKorisnik() async {
    final id = AuthProvider.korisnik?.korisnikId;
    if (id != null) {
      final result = await _provider.getById(id);
      setState(() {
        korisnik = result;
        AuthProvider.korisnik = result; // osvježi globalno
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (korisnik == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacije o profilu'),
        backgroundColor: const Color(0xFF50C878),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipOval(
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: korisnik!.slika != null && korisnik!.slika!.isNotEmpty
                      ? imageFromString(korisnik!.slika!)
                      : const Icon(Icons.person, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildDisabledField("Ime", korisnik!.ime),
            _buildDisabledField("Prezime", korisnik!.prezime),
            _buildDisabledField("Korisničko ime", korisnik!.korisnickoIme),
            _buildDisabledField("Email", korisnik!.email),
            _buildDisabledField("Telefon", korisnik!.telefon),
            _buildDisabledField(
              "Datum rođenja",
              korisnik!.datumRodjenja != null
                  ? "${korisnik!.datumRodjenja!.day.toString().padLeft(2, '0')}.${korisnik!.datumRodjenja!.month.toString().padLeft(2, '0')}.${korisnik!.datumRodjenja!.year}"
                  : null,
            ),
            _buildDisabledField("Uloga", korisnik!.ulogaNaziv),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: value?.isNotEmpty == true ? value : '-',
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
