import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _provider = KorisnikProvider();

  final korisnickoImeController = TextEditingController();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final lozinkaController = TextEditingController();
  final potvrdaLozinkeController = TextEditingController();
  final datumRodjenjaController = TextEditingController();

  DateTime? selectedDate;
  Uint8List? imageData;
  bool isLoading = false;
  bool showSlikaError = false;
  String? korisnickoImeError;
  String? emailError;
  String? generalErrorMessage;

  @override
  void initState() {
    super.initState();
    _fillFields();
  }

  void _fillFields() {
    final korisnik = AuthProvider.korisnik!;
    korisnickoImeController.text = korisnik.korisnickoIme;
    imeController.text = korisnik.ime;
    prezimeController.text = korisnik.prezime;
    emailController.text = korisnik.email ?? '';
    telefonController.text = korisnik.telefon ?? '';
    datumRodjenjaController.text = korisnik.datumRodjenja != null
        ? "${korisnik.datumRodjenja!.day.toString().padLeft(2, '0')}.${korisnik.datumRodjenja!.month.toString().padLeft(2, '0')}.${korisnik.datumRodjenja!.year}"
        : '';
    selectedDate = korisnik.datumRodjenja;

    if (korisnik.slika != null) {
      imageData = base64Decode(korisnik.slika!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        generalErrorMessage = null;
        imageData = bytes;
        showSlikaError = false;
      });
    }
  }

  Widget _buildImagePreview() {
    Widget child;
    if (imageData != null) {
      child = Image.memory(imageData!, fit: BoxFit.cover);
    } else {
      child = Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
    }

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (imageData == null) {
      setState(() => showSlikaError = true);
      return;
    }

    final korisnik = AuthProvider.korisnik!;
    setState(() => isLoading = true);

    final result = await _provider.validateUsernameEmail(
      korisnickoIme: korisnickoImeController.text,
      email: emailController.text,
      ignoreId: korisnik.korisnikId,
    );

    if (result["valid"] == false) {
      List errors = result["errors"];

      setState(() {
        korisnickoImeError = null;
        emailError = null;
        generalErrorMessage = null;

        for (var e in errors) {
          if (e.toLowerCase().contains("korisničko ime")) {
            korisnickoImeError = e;
          } else if (e.toLowerCase().contains("email")) {
            emailError = e;
          }
        }
      });

      _formKey.currentState?.validate();
      setState(() => isLoading = false);
      return;
    }

    final request = {
      "korisnickoIme": korisnickoImeController.text,
      "ime": imeController.text,
      "prezime": prezimeController.text,
      "datumRodjenja": selectedDate?.toIso8601String(),
      "email": emailController.text,
      "telefon": telefonController.text,
      "slika": base64Encode(imageData!),
      "lozinka": lozinkaController.text.isNotEmpty
          ? lozinkaController.text
          : null,
      "lozinkaPotvrda": lozinkaController.text.isNotEmpty
          ? potvrdaLozinkeController.text
          : null,
    };

    try {
      final updated = await _provider.updateMobile(
        korisnik.korisnikId!,
        request,
      );

      final oldUsername = korisnik.korisnickoIme;
      final newUsername = updated.korisnickoIme;
      final isUsernameChanged = oldUsername != newUsername;
      final isPasswordChanged = lozinkaController.text.isNotEmpty;

      AuthProvider.korisnik = updated;

      if (isUsernameChanged || isPasswordChanged) {
        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Sigurnosna provjera"),
            content: const Text(
              "Promijenili ste korisničko ime ili lozinku. Radi sigurnosti, potrebno je da se ponovo prijavite.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("U redu"),
              ),
            ],
          ),
        );

        AuthProvider.logout(context);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        return;
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil uspješno ažuriran.")),
        );
      }
    } catch (e) {
      setState(() {
        generalErrorMessage = "Došlo je do greške. Pokušajte ponovo.";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    bool isEmail = false,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: maxLength,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(labelText: label, counterText: ''),
      validator: (value) {
        if ((value == null || value.trim().isEmpty) &&
            label != "Šifra" &&
            label != "Potvrda šifre") {
          return "$label je obavezno";
        }

        if (label == "Korisničko ime") {
          if (korisnickoImeError != null) return korisnickoImeError;
        }

        if (label == "Email") {
          if (emailError != null) return emailError;
          if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value!.trim())) {
            return "Unesite ispravan email";
          }
        }

        if (label == "Šifra" && value!.isNotEmpty && value.length < 6) {
          return "Minimalno 6 karaktera";
        }

        if (label == "Potvrda šifre" &&
            lozinkaController.text != potvrdaLozinkeController.text) {
          return "Šifre se ne poklapaju";
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uredi profil"),
        backgroundColor: const Color(0xFF50C878),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePreview(),
              if (showSlikaError)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Slika je obavezna",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Promijeni sliku"),
              ),
              const SizedBox(height: 24),
              _buildField(
                korisnickoImeController,
                "Korisničko ime",
                maxLength: 50,
              ),
              const SizedBox(height: 12),
              _buildField(imeController, "Ime", maxLength: 100),
              const SizedBox(height: 12),
              _buildField(prezimeController, "Prezime", maxLength: 100),
              const SizedBox(height: 12),
              _buildField(
                emailController,
                "Email",
                isEmail: true,
                maxLength: 100,
              ),

              const SizedBox(height: 12),
              _buildField(telefonController, "Telefon", maxLength: 20),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                      datumRodjenjaController.text =
                          "${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}";
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: datumRodjenjaController,
                    decoration: const InputDecoration(
                      labelText: "Datum rođenja",
                    ),
                    validator: (value) => selectedDate == null
                        ? "Datum rođenja je obavezan"
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildField(
                lozinkaController,
                "Šifra",
                obscure: true,
                maxLength: 20,
              ),
              const SizedBox(height: 12),
              _buildField(
                potvrdaLozinkeController,
                "Potvrda šifre",
                obscure: true,
                maxLength: 20,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Text("Sačuvaj"),
                ),
              ),
              const SizedBox(height: 12),
              if (generalErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    generalErrorMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Nazad"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
