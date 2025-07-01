import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'package:plantcare_desktop/providers/kategorija_provider.dart';

class KategorijaForm extends StatefulWidget {
  final Kategorija? kategorija;
  final void Function()? onSuccess;

  const KategorijaForm({super.key, this.kategorija, this.onSuccess});

  @override
  State<KategorijaForm> createState() => _KategorijaFormState();
}

class _KategorijaFormState extends State<KategorijaForm> {
  final _formKey = GlobalKey<FormState>();
  final nazivController = TextEditingController();
  final kategorijaProvider = KategorijaProvider();

  @override
  void initState() {
    super.initState();
    if (widget.kategorija != null) {
      nazivController.text = widget.kategorija!.naziv;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final request = {'naziv': nazivController.text};

    if (widget.kategorija == null) {
      await kategorijaProvider.insert(request);
    } else {
      await kategorijaProvider.update(widget.kategorija!.kategorijaId, request);
    }
    if (!mounted) return;
    if (widget.onSuccess != null) widget.onSuccess!();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.kategorija == null ? 'Dodaj kategoriju' : 'Uredi kategoriju',
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: nazivController,
            decoration: const InputDecoration(labelText: 'Naziv'),
            maxLength: 100,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Unesite naziv';
              }
              if (value.length > 100) {
                return 'Maksimalno 100 karaktera';
              }
              return null;
            },
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
