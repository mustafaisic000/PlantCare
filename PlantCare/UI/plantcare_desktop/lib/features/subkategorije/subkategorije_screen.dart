import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'package:plantcare_desktop/models/subkategorije_model.dart';
import 'package:plantcare_desktop/providers/subkategorije_provider.dart';
import 'subkategorije_form.dart';

class SubkategorijeScreen extends StatefulWidget {
  const SubkategorijeScreen({super.key});

  @override
  State<SubkategorijeScreen> createState() => _SubkategorijeScreenState();
}

class _SubkategorijeScreenState extends State<SubkategorijeScreen> {
  final SubkategorijaProvider _provider = SubkategorijaProvider();
  List<Subkategorija> _data = [];
  late List<TableColumnConfig<Subkategorija>> _columns;

  final nazivController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getSubkategorijaTableConfig();
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

  void _openForm({Subkategorija? subkategorija}) {
    showDialog(
      context: context,
      builder: (_) =>
          SubkategorijeForm(subkategorija: subkategorija, onSuccess: loadData),
    );
  }

  void _viewDetails(Subkategorija subkategorija) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalji subkategorije'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Naziv: ${subkategorija.naziv}"),
            Text("Kategorija: ${subkategorija.kategorijaNaziv ?? 'N/A'}"),
          ],
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

  void _deleteDummy(Subkategorija subkategorija) {
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
            child: GenericPaginatedTable<Subkategorija>(
              data: _data,
              columns: _columns.map((e) => e.label).toList(),
              getValue: (s, col) =>
                  _columns.firstWhere((c) => c.label == col).valueBuilder!(s),
              rowsPerPage: _rowsPerPage,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onEdit: (s) => _openForm(subkategorija: s),
              onView: _viewDetails,
              onDelete: _deleteDummy,
            ),
          ),
        ),
      ],
    );
  }
}
