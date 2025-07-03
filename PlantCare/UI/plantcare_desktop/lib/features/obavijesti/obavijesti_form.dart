import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/obavijesti_model.dart';
import 'package:plantcare_desktop/providers/obavijest_provider.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart';

class ObavijestForm extends StatefulWidget {
  final Obavijest? existing;

  const ObavijestForm({super.key, this.existing});

  @override
  State<ObavijestForm> createState() => _ObavijestFormState();
}

class _ObavijestFormState extends State<ObavijestForm> {
  final _formKey = GlobalKey<FormState>();
  final naslovController = TextEditingController();
  final sadrzajController = TextEditingController();
  bool aktivan = false;

  final ObavijestProvider _provider = ObavijestProvider();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      naslovController.text = widget.existing!.naslov;
      sadrzajController.text = widget.existing!.sadrzaj;
      aktivan = widget.existing!.aktivan;
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'naslov': naslovController.text,
      'sadrzaj': sadrzajController.text,
      'aktivan': aktivan,
    };

    if (widget.existing == null) {
      final korisnikId = AuthProvider.korisnik?.korisnikId ?? 1;
      data['korisnikId'] = korisnikId;
      data['koPrima'] = 'Mobilna';
      await _provider.insert(data);
    } else {
      await _provider.update(widget.existing!.obavijestId, data);
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.existing == null ? 'Dodaj obavijest' : 'Uredi obavijest',
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: naslovController,
                maxLength: 100,
                decoration: const InputDecoration(labelText: 'Naslov'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite naslov';
                  } else if (value.length > 100) {
                    return 'Naslov može imati maksimalno 100 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: sadrzajController,
                maxLength: 250,
                minLines: 5,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Sadržaj',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite sadržaj';
                  } else if (value.length > 250) {
                    return 'Maksimalno 250 karaktera';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Objavljena:'),
                  const SizedBox(width: 12),
                  Switch(
                    value: aktivan,
                    onChanged: (val) => setState(() => aktivan = val),
                  ),
                ],
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
        ElevatedButton(onPressed: _submit, child: const Text('Sačuvaj')),
      ],
    );
  }
}
