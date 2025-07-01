import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final korisnickoImeController = TextEditingController();
  final lozinkaController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final datumRodjenjaController = TextEditingController();

  DateTime? selectedDate;
  final KorisnikProvider _provider = KorisnikProvider();

  Uint8List? imageData;
  bool showSlikaError = false;
  bool isLoading = false;
  String? korisnickoImeError;
  String? emailError;

  String encodeBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) {
        print("⚠️ Nije odabrana nijedna slika.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nije odabrana nijedna slika.")),
        );
        return;
      }

      final bytes = await file.readAsBytes();

      if (bytes.isNotEmpty) {
        print("✅ Slika učitana: ${bytes.lengthInBytes} bajtova");
        setState(() {
          imageData = bytes;
          showSlikaError = false;
        });
      } else {
        throw Exception("Slika je prazna.");
      }
    } catch (e) {
      print("❌ Greška u pickImage: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška pri dodavanju slike.")));
    }
  }

  Widget _buildImagePreview() {
    Widget child;

    if (imageData != null) {
      child = Image.memory(
        imageData!,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      );
    } else {
      child = Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
    }

    return Container(
      width: 140,
      height: 140,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: child,
    );
  }

  Future<void> _submit() async {
    final isFormValid = _formKey.currentState!.validate();
    final hasImage = imageData != null;

    setState(() {
      showSlikaError = !hasImage;
    });

    if (!isFormValid || !hasImage) return;

    setState(() => isLoading = true);

    // 1. ✅ Provjera korisničkog imena i emaila
    final result = await _provider.validateUsernameEmail(
      korisnickoIme: korisnickoImeController.text,
      email: emailController.text,
      ignoreId: null,
    );

    if (result["valid"] == false) {
      List errors = result["errors"];

      setState(() {
        korisnickoImeError = null;
        emailError = null;

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

    // 2. 📦 Kreiranje requesta
    final Map<String, dynamic> request = {
      "ime": imeController.text,
      "prezime": prezimeController.text,
      "korisnickoIme": korisnickoImeController.text,
      "lozinka": lozinkaController.text,
      "lozinkaPotvrda": lozinkaController.text,
      "email": emailController.text,
      "telefon": telefonController.text,
      "ulogaId": 3,
      "slika": base64Encode(imageData!),
      "datumRodjenja": selectedDate?.toIso8601String(),
    };

    try {
      await _provider.insertKorisnik(request);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Uspješno"),
          content: const Text("Račun je kreiran! Možete se prijaviti."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // back to login
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("❌ Greška prilikom registracije: $e");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Greška"),
          content: const Text("Registracija nije uspjela."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Zatvori"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    int? maxLength,
    bool isEmail = false,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: maxLength,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        errorText: errorText,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label je obavezno";
        }

        if (isEmail &&
            !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value.trim())) {
          return "Unesite ispravan email";
        }

        if (label == "Šifra") {
          if (value.length < 6) return "Min. 6 karaktera";
          if (value.length > 20) return "Max 20 karaktera";
        } else if (maxLength != null && value.length > maxLength) {
          return "Max $maxLength karaktera";
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildImagePreview(),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Dodaj sliku"),
                ),
                if (showSlikaError)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Slika je obavezna",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                _buildField(imeController, "Ime", maxLength: 100),
                const SizedBox(height: 12),
                _buildField(prezimeController, "Prezime", maxLength: 100),
                const SizedBox(height: 12),
                _buildField(
                  korisnickoImeController,
                  "Korisničko ime",
                  maxLength: 20,
                  errorText: korisnickoImeError,
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
                  emailController,
                  "Email",
                  isEmail: true,
                  maxLength: 100,
                  errorText: emailError,
                ),
                const SizedBox(height: 12),
                _buildField(telefonController, "Broj telefona", maxLength: 20),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                        hintText: "DD.MM.GGGG",
                      ),
                      validator: (value) {
                        if (selectedDate == null) {
                          return "Datum rođenja je obavezan";
                        }
                        return null;
                      },
                    ),
                  ),
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
                        : const Text("Kreirajte račun"),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Imate račun? Logirajte se"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
