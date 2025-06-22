import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/providers/korisnici_provider.dart';
import 'package:plantcare_desktop/providers/util.dart';
import 'package:plantcare_desktop/providers/uloga_provider.dart';
import 'package:plantcare_desktop/models/uloga_model.dart';

class KorisnikForm extends StatefulWidget {
  final Korisnik? korisnik;
  final bool readOnly;

  const KorisnikForm({this.korisnik, this.readOnly = false, super.key});

  @override
  State<KorisnikForm> createState() => _KorisnikFormState();
}

class _KorisnikFormState extends State<KorisnikForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  late TextEditingController imeController;
  late TextEditingController prezimeController;
  late TextEditingController korisnickoImeController;
  late TextEditingController emailController;
  late TextEditingController telefonController;
  late TextEditingController datumRodjenjaController;
  int? selectedUlogaId;
  String? base64Slika;
  List<Uloga> uloge = [];

  @override
  void initState() {
    super.initState();
    final k = widget.korisnik;
    imeController = TextEditingController(text: k?.ime ?? '');
    prezimeController = TextEditingController(text: k?.prezime ?? '');
    korisnickoImeController = TextEditingController(
      text: k?.korisnickoIme ?? '',
    );
    emailController = TextEditingController(text: k?.email ?? '');
    telefonController = TextEditingController(text: k?.telefon ?? '');
    datumRodjenjaController = TextEditingController(
      text: formatDate(k?.datumRodjenja),
    );
    selectedUlogaId = k?.ulogaId;
    base64Slika = k?.slika;
    loadUloge();
  }

  Future<void> loadUloge() async {
    final result = await UlogaProvider().get();
    setState(() => uloge = result.result);
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        base64Slika = base64Encode(result.files.single.bytes!);
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    final provider = context.read<KorisnikProvider>();

    final korisnik = Korisnik(
      korisnikId: widget.korisnik?.korisnikId,
      ime: imeController.text,
      prezime: prezimeController.text,
      korisnickoIme: korisnickoImeController.text,
      email: emailController.text,
      telefon: telefonController.text,
      datumRodjenja: parseDate(datumRodjenjaController.text),
      ulogaId: selectedUlogaId,
      status: true,
      slika: base64Slika,
    );

    try {
      if (widget.korisnik == null) {
        await provider.insertKorisnik(korisnik);
      } else {
        await provider.updateKorisnik(korisnik);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.korisnik == null
                        ? 'Novi korisnik'
                        : 'Uredi korisnika',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slika
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: base64Slika != null && base64Slika!.isNotEmpty
                            ? Image.memory(
                                base64Decode(base64Slika!),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.png',
                                width: 140,
                                height: 140,
                              ),
                      ),
                      const SizedBox(height: 8),
                      if (!widget.readOnly)
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Dodaj sliku"),
                        ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Polja
                  Expanded(
                    child: Wrap(
                      runSpacing: 12,
                      spacing: 12,
                      children: [
                        _buildTextField(
                          imeController,
                          "Ime",
                          readOnly: widget.readOnly,
                        ),
                        _buildTextField(
                          prezimeController,
                          "Prezime",
                          readOnly: widget.readOnly,
                        ),
                        _buildTextField(
                          korisnickoImeController,
                          "Korisničko ime",
                          readOnly: widget.readOnly,
                        ),
                        _buildTextField(
                          emailController,
                          "Email",
                          readOnly: widget.readOnly,
                        ),
                        _buildTextField(
                          telefonController,
                          "Telefon",
                          readOnly: widget.readOnly,
                        ),
                        _buildDateField(
                          datumRodjenjaController,
                          "Datum rođenja",
                          readOnly: widget.readOnly,
                        ),
                        _buildDropdownField("Uloga", uloge, selectedUlogaId, (
                          val,
                        ) {
                          setState(() => selectedUlogaId = val);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!widget.readOnly)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Sačuvaj"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool readOnly = false,
  }) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Obavezno polje" : null,
      ),
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label, {
    bool readOnly = false,
  }) {
    return SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: readOnly
            ? null
            : () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) controller.text = formatDate(picked);
              },
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? "Obavezno polje" : null,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<Uloga> items,
    int? value,
    void Function(int?) onChanged,
  ) {
    return SizedBox(
      width: 300,
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (u) =>
                  DropdownMenuItem<int>(value: u.ulogaId, child: Text(u.naziv)),
            )
            .toList(),
        onChanged: widget.readOnly ? null : onChanged,
        validator: (val) => val == null ? "Obavezno polje" : null,
      ),
    );
  }
}
