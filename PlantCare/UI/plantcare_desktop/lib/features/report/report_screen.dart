import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'package:plantcare_desktop/models/report_model.dart';
import 'package:plantcare_desktop/providers/report_provider.dart';
import 'report_form.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportProvider _provider = ReportProvider();
  List<Report> _data = [];
  late List<TableColumnConfig<Report>> _columns;

  final searchController = TextEditingController();
  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getReportTableConfig();
    loadData();
  }

  Future<void> loadData() async {
    final filters = {
      if (searchController.text.isNotEmpty) 'naslov': searchController.text,
    };
    final result = await _provider.get(filter: filters);
    setState(() {
      _data = result.result;
      _currentPage = 0;
    });
  }

  void _onPageChanged(int newPage) {
    setState(() => _currentPage = newPage);
  }

  void _clearFilters() {
    searchController.clear();
    loadData();
  }

  void _openInsertForm() {
    showDialog(
      context: context,
      builder: (_) => ReportForm(report: null, onSuccess: loadData),
    );
  }

  void _viewDetails(Report report) {
    showDialog(
      context: context,
      builder: (_) => ReportForm(
        report: report,
        // readOnly: true, // možeš obrisati ili ostaviti ako budeš koristio readOnly
        onSuccess: loadData,
      ),
    );
  }

  void _deleteDummy(Report report) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Brisanje nije omogućeno.")));
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
                      width: 220,
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => loadData(),
                        decoration: const InputDecoration(
                          labelText: 'Pretraga po naslovu posta',
                        ),
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
                  onPressed: _openInsertForm,
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
            child: GenericPaginatedTable<Report>(
              data: _data,
              columns: _columns.map((e) => e.label).toList(),
              getValue: (o, col) =>
                  _columns.firstWhere((c) => c.label == col).valueBuilder!(o),
              rowsPerPage: _rowsPerPage,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onView: (r) => _viewDetails(r),
              onDelete: _deleteDummy,
            ),
          ),
        ),
      ],
    );
  }
}
