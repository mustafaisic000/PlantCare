import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/providers/korisnici_provider.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/features/korisnici/korisnici_form.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'package:plantcare_desktop/providers/uloga_provider.dart';
import 'package:plantcare_desktop/models/uloga_model.dart';

class KorisniciScreen extends StatefulWidget {
  const KorisniciScreen({super.key});

  @override
  State<KorisniciScreen> createState() => _KorisniciScreenState();
}

class _KorisniciScreenState extends State<KorisniciScreen> {
  final KorisnikProvider _provider = KorisnikProvider();
  final UlogaProvider _ulogaProvider = UlogaProvider();
  List<Korisnik> _data = [];
  late List<TableColumnConfig<Korisnik>> _columns;

  final imeController = TextEditingController();
  final prezimeController = TextEditingController();
  int? selectedUlogaId;
  List<Uloga> uloge = [];

  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getKorisnikTableConfig();
    loadUloge();
    loadData();
  }

  Future<void> loadUloge() async {
    final result = await _ulogaProvider.get();
    setState(() => uloge = result.result);
  }

  Future<void> loadData() async {
    final filters = {
      'includeUloga': 'true',
      'status': 'true',
      if (imeController.text.isNotEmpty) 'imeGTE': imeController.text,
      if (prezimeController.text.isNotEmpty)
        'prezimeGTE': prezimeController.text,
      if (selectedUlogaId != null) 'ulogaId': selectedUlogaId,
    };

    final result = await _provider.get(filter: filters);
    setState(() {
      _data = result.result;
      _currentPage = 0;
    });
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _showDetails(Korisnik k, {bool readOnly = true}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: KorisnikForm(
            korisnik: k,
            readOnly: readOnly,
            onClose: loadData,
          ),
        ),
      ),
    );
  }

  void _showAddForm() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(child: KorisnikForm(onClose: loadData)),
      ),
    );
  }

  void _clearFilters() {
    imeController.clear();
    prezimeController.clear();
    setState(() {
      selectedUlogaId = null;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 180,
              child: TextField(
                controller: imeController,
                onChanged: (_) => loadData(),
                decoration: const InputDecoration(labelText: 'Ime'),
              ),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                controller: prezimeController,
                onChanged: (_) => loadData(),
                decoration: const InputDecoration(labelText: 'Prezime'),
              ),
            ),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<int>(
                value: selectedUlogaId,
                decoration: const InputDecoration(labelText: 'Uloga'),
                items: uloge
                    .map(
                      (u) => DropdownMenuItem(
                        value: u.ulogaId,
                        child: Text(u.naziv),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() => selectedUlogaId = val);
                  loadData();
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear),
              label: const Text('Očisti filtere'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _showAddForm,
              icon: const Icon(Icons.add),
              label: const Text('Dodaj'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GenericPaginatedTable<Korisnik>(
            data: _data,
            columns: _columns.map((e) => e.label).toList(),
            getValue: (k, col) =>
                _columns.firstWhere((c) => c.label == col).valueBuilder!(k),
            rowsPerPage: _rowsPerPage,
            currentPage: _currentPage,
            onPageChanged: _onPageChanged,
            onView: (k) => _showDetails(k, readOnly: true),
            onEdit: (k) => _showDetails(k, readOnly: false),
            onDelete: (k) async {
              await _provider.deleteKorisnik(k.korisnikId);
              await loadData();
            },
          ),
        ),
      ],
    );
  }
}
