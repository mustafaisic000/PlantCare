import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/kategorije_transakcije2025_model.dart';
import 'package:plantcare_mobile/models/transakcija25062025_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/kategorije_transakcije2025_provider.dart';
import 'package:plantcare_mobile/providers/transakcija25062025_provider.dart';
import 'package:intl/intl.dart';

class FrmTransakcije25062025NewScreen extends StatefulWidget {
  const FrmTransakcije25062025NewScreen({super.key});

  @override
  State<FrmTransakcije25062025NewScreen> createState() =>
      _FrmTransakcije25062025NewScreenState();
}

class _FrmTransakcije25062025NewScreenState
    extends State<FrmTransakcije25062025NewScreen> {
  final _transakcijaProvider = Transakcija25062025Provider();
  final _kategorijaProvider = KategorijeTransakcije2025Provider();

  List<KategorijeTransakcije2025> _kategorije = [];
  KategorijeTransakcije2025? _odabranaKategorija;

  double? _iznos;
  String? _opis;
  DateTime? _datum = DateTime.now();
  String _status = "Planirano";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final response = await _kategorijaProvider.get();
    setState(() {
      _kategorije = response.result;
    });
  }

  void _showError(String poruka) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Greška"),
        content: Text(poruka),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _odaberiDatum() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _datum ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _datum = picked;
      });
    }
  }

  Future<void> _spasiTransakciju() async {
    if (_iznos == null || _iznos! <= 0)
      return _showError("Unesite validan iznos.");
    if (_opis == null || _opis!.isEmpty) return _showError("Unesite opis.");
    if (_datum == null) return _showError("Odaberite datum.");
    if (_odabranaKategorija == null) return _showError("Odaberite kategoriju.");

    final korisnik = AuthProvider.korisnik;

    try {
      await _transakcijaProvider.insert(
        Transakcija25062025(
          transakcija25062025Id: 0,
          korisnikId: korisnik?.korisnikId,
          iznos: _iznos!,
          datumTransakcije: _datum!,
          opis: _opis!,
          kategorijaTransakcije25062025Id:
              _odabranaKategorija!.kategorijaTransakcije25062025Id,
          status: _status,
          korisnik: null,
          kategorijaTransakcije25062025: null,
        ),
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Uspjeh"),
          content: const Text("Transakcija uspješno dodana."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // zatvori dijalog
                Navigator.pop(
                  context,
                  true,
                ); // zatvori formu i javi parentu da refresha
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError("Greška: ${e.toString()}");
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat("dd.MM.yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dodaj transakciju")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Iznos",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _iznos = double.tryParse(value);
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Opis",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _opis = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _odaberiDatum,
              child: Text(
                _datum == null
                    ? "Odaberite datum"
                    : "Datum: ${_formatDate(_datum)}",
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<KategorijeTransakcije2025>(
              value: _odabranaKategorija,
              decoration: const InputDecoration(
                labelText: "Kategorija",
                border: OutlineInputBorder(),
              ),
              items: _kategorije.map((k) {
                return DropdownMenuItem(
                  value: k,
                  child: Text(k.nazivKategorije),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _odabranaKategorija = val;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Planirano", child: Text("Planirano")),
                DropdownMenuItem(
                  value: "Realizovano",
                  child: Text("Realizovano"),
                ),
                DropdownMenuItem(value: "Otkazano", child: Text("Otkazano")),
              ],
              onChanged: (val) {
                setState(() {
                  _status = val!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _spasiTransakciju,
              child: const Text("Dodaj transakciju"),
            ),
          ],
        ),
      ),
    );
  }
}
