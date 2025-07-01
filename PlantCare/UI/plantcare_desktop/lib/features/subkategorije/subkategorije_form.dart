import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'package:plantcare_desktop/models/subkategorije_model.dart';
import 'package:plantcare_desktop/providers/kategorija_provider.dart';
import 'package:plantcare_desktop/providers/subkategorije_provider.dart';

class SubkategorijeForm extends StatefulWidget {
  final Subkategorija? subkategorija;
  final void Function()? onSuccess;

  const SubkategorijeForm({super.key, this.subkategorija, this.onSuccess});

  @override
  State<SubkategorijeForm> createState() => _SubkategorijeFormState();
}

class _SubkategorijeFormState extends State<SubkategorijeForm> {
  final _formKey = GlobalKey<FormState>();
  final nazivController = TextEditingController();

  final kategorijeProvider = KategorijaProvider();
  final subkategorijeProvider = SubkategorijaProvider();

  List<Kategorija> kategorije = [];
  int? selectedKategorijaId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDropdown();
  }

  Future<void> _loadDropdown() async {
    final result = await kategorijeProvider.get();
    kategorije = result.result;

    if (widget.subkategorija != null) {
      nazivController.text = widget.subkategorija!.naziv;
      selectedKategorijaId = widget.subkategorija!.kategorijaId;
    }

    setState(() {
      isLoading = false;
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final request = {
      'naziv': nazivController.text,
      'kategorijaId': selectedKategorijaId,
    };

    if (widget.subkategorija == null) {
      await subkategorijeProvider.insert(request);
    } else {
      await subkategorijeProvider.update(
        widget.subkategorija!.subkategorijaId,
        request,
      );
    }

    if (!mounted) return;
    widget.onSuccess?.call();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.subkategorija == null
            ? 'Dodaj podkategoriju'
            : 'Uredi podkategoriju',
      ),
      content: SizedBox(
        width: 400,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nazivController,
                      decoration: const InputDecoration(labelText: 'Naziv'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Unesite naziv';
                        }
                        if (value.length > 100) {
                          return 'Maksimalno 100 karaktera';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedKategorijaId,
                      items: kategorije
                          .map(
                            (k) => DropdownMenuItem(
                              value: k.kategorijaId,
                              child: Text(k.naziv),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedKategorijaId = val),
                      decoration: const InputDecoration(
                        labelText: 'Kategorija',
                      ),
                      validator: (value) =>
                          value == null ? 'Odaberite kategoriju' : null,
                    ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Odustani'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Sačuvaj')),
      ],
    );
  }
}
