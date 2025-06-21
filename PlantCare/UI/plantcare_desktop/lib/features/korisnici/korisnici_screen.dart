import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:plantcare_desktop/providers/korisnici_provider.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/features/korisnici/korisnici_form.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';

class KorisniciScreen extends StatefulWidget {
  const KorisniciScreen({super.key});

  @override
  State<KorisniciScreen> createState() => _KorisniciScreenState();
}

class _KorisniciScreenState extends State<KorisniciScreen> {
  final KorisnikProvider _provider = KorisnikProvider();
  List<Korisnik> _data = [];
  late List<TableColumnConfig<Korisnik>> _columns;

  final TextEditingController imeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getKorisnikTableConfig();
    loadData();
  }

  Future<void> loadData({Map<String, dynamic>? search}) async {
    final filters = {
      'includeUloga': 'true',
      'status': 'true',
      if (search != null) ...search,
    };

    final result = await _provider.get(filter: filters);
    setState(() {
      _data = result.result;
      _currentPage = 0;
    });
  }

  void _onSearchPressed() {
    final filters = {
      if (imeController.text.isNotEmpty) 'imeGTE': imeController.text,
      if (emailController.text.isNotEmpty) 'email': emailController.text,
    };
    loadData(search: filters);
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
          child: KorisnikForm(korisnik: k, readOnly: readOnly),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: imeController,
                  decoration: const InputDecoration(labelText: 'Ime'),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _onSearchPressed,
                child: const Text('Pretraga'),
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
      ),
    );
  }
}
