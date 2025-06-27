import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/kategorija_model.dart';
import 'package:plantcare_mobile/models/subkategorije_model.dart';
import 'package:plantcare_mobile/providers/kategorija_provider.dart';
import 'package:plantcare_mobile/providers/subkategorije_provider.dart';

class DodajScreen extends StatefulWidget {
  const DodajScreen({super.key});

  @override
  DodajScreenState createState() => DodajScreenState();
}

class DodajScreenState extends State<DodajScreen> {
  final KategorijaProvider _kategorijaProvider = KategorijaProvider();
  final SubkategorijaProvider _subkategorijaProvider = SubkategorijaProvider();

  List<Kategorija> _kategorije = [];
  List<Subkategorija> _subkategorije = [];

  @override
  void initState() {
    super.initState();
    loadDropdowns();
  }

  Future<void> loadDropdowns() async {
    final katResult = await _kategorijaProvider.get();
    final subResult = await _subkategorijaProvider.get();

    setState(() {
      _kategorije = katResult.result;
      _subkategorije = subResult.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _kategorije.isEmpty || _subkategorije.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dodavanje sadržaja',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Kategorija'),
                    items: _kategorije
                        .map(
                          (k) => DropdownMenuItem<int>(
                            value: k.kategorijaId,
                            child: Text(k.naziv),
                          ),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Subkategorija',
                    ),
                    items: _subkategorije
                        .map(
                          (s) => DropdownMenuItem<int>(
                            value: s.subkategorijaId,
                            child: Text(s.naziv),
                          ),
                        )
                        .toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
    );
  }
}
