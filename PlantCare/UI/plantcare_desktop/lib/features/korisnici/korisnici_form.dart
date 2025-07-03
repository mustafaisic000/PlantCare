import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/providers/korisnici_provider.dart';
import 'package:plantcare_desktop/providers/uloga_provider.dart';
import 'package:plantcare_desktop/providers/util.dart';

class KorisnikForm extends StatefulWidget {
  final Korisnik? korisnik;
  final bool readOnly;
  final VoidCallback? onClose;

  const KorisnikForm({
    super.key,
    this.korisnik,
    this.readOnly = false,
    this.onClose,
  });

  @override
  State<KorisnikForm> createState() => _KorisnikFormState();
}

class _KorisnikFormState extends State<KorisnikForm> {
  final _formKey = GlobalKey<FormState>();
  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  final emailController = TextEditingController();
  final telefonController = TextEditingController();
  final korisnickoImeController = TextEditingController();
  final datumController = TextEditingController();
  final lozinkaController = TextEditingController();

  final KorisnikProvider provider = KorisnikProvider();
  final UlogaProvider ulogaProvider = UlogaProvider();

  int ulogaId = 3; // default "User"
  Uint8List? imageData;
  String? originalSlika;
  bool showSlikaError = false;
  List<DropdownMenuItem<int>> ulogeItems = [];
  String? korisnickoImeError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    loadUloge();

    if (widget.korisnik != null) {
      final k = widget.korisnik!;
      imeController.text = k.ime;
      prezimeController.text = k.prezime;
      emailController.text = k.email ?? '';
      telefonController.text = k.telefon ?? '';
      korisnickoImeController.text = k.korisnickoIme;
      datumController.text = k.datumRodjenja != null
          ? formatDate(k.datumRodjenja)
          : '';
      ulogaId = k.ulogaId;
      originalSlika = k.slika;
    }
  }

  Future<void> loadUloge() async {
    final data = await ulogaProvider.get();
    setState(() {
      ulogeItems = data.result.map((uloga) {
        return DropdownMenuItem<int>(
          value: uloga.ulogaId,
          child: Text(uloga.naziv),
        );
      }).toList();
    });
  }

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

  Widget buildImagePreview() {
    Widget imageWidget;

    if (imageData != null) {
      imageWidget = Image.memory(imageData!, fit: BoxFit.cover);
    } else if (originalSlika != null && originalSlika!.isNotEmpty) {
      try {
        final decoded = base64Decode(originalSlika!);
        imageWidget = Image.memory(decoded, fit: BoxFit.cover);
      } catch (_) {
        imageWidget = Image.asset(
          'assets/images/placeholder.png',
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/images/placeholder.png',
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: 200,
      height: 220,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: imageWidget,
    );
  }

  Future<void> save() async {
    final bool hasValidImage =
        imageData != null ||
        (originalSlika != null && originalSlika!.isNotEmpty);

    final bool isFormValid = _formKey.currentState!.validate();

    setState(() {
      showSlikaError = !hasValidImage;
    });

    if (!isFormValid || !hasValidImage) return;

    final korisnikMap = {
      'ime': imeController.text,
      'prezime': prezimeController.text,
      'email': emailController.text,
      'telefon': telefonController.text,
      'korisnickoIme': korisnickoImeController.text,
      'datumRodjenja': parseDate(datumController.text)!.toIso8601String(),
      'ulogaId': ulogaId,
      'slika': imageData != null
          ? base64Encode(imageData!)
          : originalSlika ?? '',
    };

    if (widget.korisnik == null) {
      final lozinka = lozinkaController.text;
      korisnikMap['lozinka'] = lozinka;
      korisnikMap['lozinkaPotvrda'] = lozinka;
    }

    try {
      korisnickoImeError = null;
      emailError = null;

      // 🔒 Backend validacija korisničkog imena i emaila
      final result = await provider.validateUsernameEmail(
        korisnickoIme: korisnickoImeController.text,
        email: emailController.text,
        ignoreId: widget.korisnik?.korisnikId,
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
        return;
      }

      // ✅ Insert ili update
      if (widget.korisnik == null) {
        await provider.insert(korisnikMap);
      } else {
        await provider.update(widget.korisnik!.korisnikId!, korisnikMap);
      }

      if (!mounted) return;
      Navigator.pop(context);
      widget.onClose?.call();
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Greška"),
          content: Text("Greška pri spremanju: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Zatvori"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.korisnik == null ? "Dodaj korisnika" : "Uredi korisnika",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 220,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: imageData != null
                            ? Image.memory(imageData!, fit: BoxFit.cover)
                            : (originalSlika != null &&
                                  originalSlika!.isNotEmpty)
                            ? Image.memory(
                                base64Decode(originalSlika!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: widget.readOnly ? null : pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text("Dodaj sliku"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          backgroundColor: const Color(0xFF50C878),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      if (showSlikaError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Slika je obavezna.",
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).inputDecorationTheme.errorStyle?.color ??
                                  const Color(0xFFB00020),
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Wrap(
                    spacing: 26,
                    runSpacing: 22,
                    children: [
                      _buildInput(imeController, "Ime"),
                      _buildInput(prezimeController, "Prezime"),
                      _buildInput(
                        korisnickoImeController,
                        "Korisničko ime",
                        errorText: korisnickoImeError,
                      ),
                      _buildInput(
                        emailController,
                        "Email",
                        errorText: emailError,
                      ),
                      _buildInput(telefonController, "Telefon"),
                      SizedBox(
                        width: 250,
                        child: GestureDetector(
                          onTap: widget.readOnly
                              ? null
                              : () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                  if (pickedDate != null) {
                                    setState(() {
                                      datumController.text = formatDate(
                                        pickedDate,
                                      );
                                    });
                                  }
                                },
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: datumController,
                              decoration: const InputDecoration(
                                labelText: "Datum rođenja",
                                hintText: "DD.MM.GGGG",
                              ),
                              validator: (value) {
                                if (widget.readOnly) return null;
                                if (value == null || value.trim().isEmpty) {
                                  return "Datum rođenja je obavezno polje";
                                }
                                if (parseDate(value) == null) {
                                  return "Datum mora biti u formatu DD.MM.GGGG";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: DropdownButtonFormField<int>(
                          value: ulogaId,
                          items: ulogeItems,
                          onChanged: widget.readOnly
                              ? null
                              : (val) => setState(() => ulogaId = val!),
                          decoration: const InputDecoration(
                            labelText: "Uloga",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (val) {
                            if (val == null) return "Odaberi ulogu";
                            return null;
                          },
                        ),
                      ),
                      if (widget.korisnik == null)
                        _buildInput(
                          lozinkaController,
                          "Šifra",
                          obscureText: true,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: widget.readOnly ? null : save,
                  child: const Text("Sačuvaj"),
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Odustani"),
                ),
              ],
            ),
            if (widget.korisnik?.korisnikId != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.lock_reset),
                label: const Text("Resetuj lozinku"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Reset lozinke"),
                      content: const Text(
                        "Da li ste sigurni da želite resetovati lozinku ovom korisniku?",
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Odustani"),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: const Text("Resetuj"),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    try {
                      await provider.resetPassword(
                        widget.korisnik!.korisnikId!,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Uspješno"),
                          content: const Text(
                            "Lozinka je resetovana i poslata na korisnikov email.",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Greška"),
                          content: Text("Reset lozinke nije uspio: $e"),
                          actions: [
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    String? hintText,
    bool obscureText = false,
    String? errorText,
  }) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        readOnly: widget.readOnly,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          errorText: errorText,
        ),
        validator: (value) {
          if (widget.readOnly) return null;

          if (value == null || value.trim().isEmpty) {
            return "$label je obavezno polje";
          }

          final length = value.trim().length;

          switch (label) {
            case "Ime":
            case "Prezime":
            case "Korisničko ime":
              if (length > 100) {
                return "Max 100 karaktera";
              }
              break;
            case "Email":
              if (length > 100) {
                return "Max 100 karaktera";
              }
              if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value.trim())) {
                return "Unesite ispravan email";
              }
              break;
            case "Telefon":
              if (length > 20) return "Max 20 karaktera";
              break;
            case "Šifra":
              if (widget.korisnik == null && length < 6) {
                return "Minimalno 6 karaktera";
              }
              if (length > 20) return "Max 20 karaktera";
              break;
          }

          return null;
        },
      ),
    );
  }
}
