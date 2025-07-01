import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'package:plantcare_desktop/models/katalog_model.dart';
import 'package:plantcare_desktop/providers/katalog_provider.dart';
import 'katalog_form.dart';

class KatalogScreen extends StatefulWidget {
  const KatalogScreen({super.key});

  @override
  State<KatalogScreen> createState() => _KatalogScreenState();
}

class _KatalogScreenState extends State<KatalogScreen> {
  final KatalogProvider _provider = KatalogProvider();
  List<Katalog> _data = [];
  late List<TableColumnConfig<Katalog>> _columns;

  final naslovController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getKatalogTableConfig();
    loadData();
  }

  Future<void> loadData() async {
    final filters = {
      if (naslovController.text.isNotEmpty) 'naslov': naslovController.text,
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
    naslovController.clear();
    loadData();
  }

  void _openForm({Katalog? katalog}) {
    showDialog(
      context: context,
      builder: (_) => KatalogForm(katalog: katalog, onClose: loadData),
    );
  }

  void _viewDetails(Katalog katalog) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalji kataloga'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Naslov: ${katalog.naslov}"),
            Text("Opis: ${katalog.opis ?? '-'}"),
            Text("Aktivan: ${katalog.aktivan ? 'Da' : 'Ne'}"),
            Text("Broj postova: ${katalog.katalogPostovi.length}"),
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

  void _deleteKatalog(Katalog katalog) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Potvrda"),
        content: const Text(
          "Da li ste sigurni da želite obrisati ovaj katalog?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Obriši"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _provider.delete(katalog.katalogId);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Katalog uspješno obrisan.")),
        );
        await loadData();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Greška: ${e.toString()}")));
      }
    }
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
                        controller: naslovController,
                        onChanged: (_) => loadData(),
                        decoration: const InputDecoration(labelText: 'Naslov'),
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
            child: GenericPaginatedTable<Katalog>(
              data: _data,
              columns: _columns.map((e) => e.label).toList(),
              getValue: (o, col) =>
                  _columns.firstWhere((c) => c.label == col).valueBuilder!(o),
              rowsPerPage: _rowsPerPage,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onEdit: (k) => _openForm(katalog: k),
              onView: _viewDetails,
              onDelete: _deleteKatalog,
            ),
          ),
        ),
      ],
    );
  }
}
