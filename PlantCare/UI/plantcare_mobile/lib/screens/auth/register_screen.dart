import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plantcare_mobile/providers/korisnici_provider.dart';

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

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;
      if (bytes == null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
      }

      if (bytes != null) {
        setState(() {
          imageData = bytes;
          showSlikaError = false;
        });
      }
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
      print("REQUEST: $request");
      print("ERROR: $e");
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
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLength: maxLength,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(labelText: label, counterText: ''),
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
