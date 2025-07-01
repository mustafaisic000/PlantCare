import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/generic_paginated_table.dart';
import 'package:plantcare_desktop/common/config/table_column_config.dart';
import 'package:plantcare_desktop/common/config/table_config.dart';
import 'package:plantcare_desktop/models/post_model.dart';
import 'package:plantcare_desktop/providers/post_provider.dart';
import 'post_form.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostProvider _provider = PostProvider();
  List<Post> _data = [];
  late List<TableColumnConfig<Post>> _columns;

  final searchController = TextEditingController();
  String? selectedPremium;

  int _currentPage = 0;
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _columns = getPostTableConfig();
    loadData();
  }

  Future<void> loadData() async {
    final filters = {
      'status': 'true',
      if (searchController.text.isNotEmpty) 'fts': searchController.text,
      if (selectedPremium != null)
        'premium': selectedPremium == "Da" ? 'true' : 'false',
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
    selectedPremium = null;
    loadData();
  }

  void _openForm({Post? post}) {
    showDialog(
      context: context,
      builder: (_) => PostForm(post: post, onClose: loadData),
    );
  }

  void _viewDetails(Post post) {
    showDialog(
      context: context,
      builder: (_) => PostForm(post: post, readOnly: true),
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
                      width: 220,
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => loadData(),
                        decoration: const InputDecoration(
                          labelText: 'Search posts',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: DropdownButtonFormField<String>(
                        value: selectedPremium,
                        onChanged: (val) {
                          setState(() => selectedPremium = val);
                          loadData();
                        },
                        decoration: const InputDecoration(labelText: 'Premium'),
                        items: const [
                          DropdownMenuItem(value: "Da", child: Text("Da")),
                          DropdownMenuItem(value: "Ne", child: Text("Ne")),
                        ],
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
            child: GenericPaginatedTable<Post>(
              data: _data,
              columns: _columns.map((e) => e.label).toList(),
              getValue: (o, col) =>
                  _columns.firstWhere((c) => c.label == col).valueBuilder!(o),
              rowsPerPage: _rowsPerPage,
              currentPage: _currentPage,
              onPageChanged: _onPageChanged,
              onEdit: (o) => _openForm(post: o),
              onView: _viewDetails,
              onDelete: (post) async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Potvrda"),
                    content: Text(
                      "Da li želiš deaktivirati post: ${post.naslov}?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Odustani"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Deaktiviraj"),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  try {
                    await _provider.softDelete(post.postId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Post je deaktiviran.")),
                    );
                    await loadData();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Greška: ${e.toString()}")),
                    );
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
