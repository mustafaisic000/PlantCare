import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'package:plantcare_desktop/providers/kategorija_provider.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'kategorije_form.dart';

class KategorijeScreen extends StatefulWidget {
  const KategorijeScreen({super.key});

  @override
  State<KategorijeScreen> createState() => _KategorijeScreenState();
}

class _KategorijeScreenState extends State<KategorijeScreen> {
  final KategorijaProvider _provider = KategorijaProvider();
  List<Kategorija> _data = [];
  late List<TableColumnConfig<Kategorija>> _columns;

  final nazivController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getKategorijaTableConfig();
    loadData();
  }

  Future<void> loadData() async {
    final filters = {
      if (nazivController.text.isNotEmpty) 'naziv': nazivController.text,
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

  void _clearFilters() {
    nazivController.clear();
    loadData();
  }

  void _openForm({Kategorija? kategorija}) {
    showDialog(
      context: context,
      builder: (_) =>
          KategorijaForm(kategorija: kategorija, onSuccess: loadData),
    );
  }

  void _viewDetails(Kategorija kategorija) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalji kategorije'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Naziv: ${kategorija.naziv}")],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Zatvori"),
          ),
        ],
      ),
    );
  }

  void _deleteDummy(Kategorija kategorija) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Delete funkcionalnost još nije implementirana."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: nazivController,
                        onChanged: (_) => loadData(),
                        decoration: const InputDecoration(labelText: 'Naziv'),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear),
                      label: const Text('Očisti filtere'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Dodaj'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: GenericPaginatedTable<Kategorija>(
              data: _data,
              columns: _columns.map((e) => e.label).toList(),
              getValue: (k, col) =>
                  _columns.firstWhere((c) => c.label == col).valueBuilder!(k),
              rowsPerPage: _rowsPerPage,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onEdit: (k) => _openForm(kategorija: k),
              onView: _viewDetails,
              onDelete: _deleteDummy,
            ),
          ),
        ),
      ],
    );
  }
}
