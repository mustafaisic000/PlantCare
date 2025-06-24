import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';
import 'package:plantcare_desktop/common/widgets/notification_card.dart';

class NotifikacijeScreen extends StatefulWidget {
  const NotifikacijeScreen({super.key});

  @override
  State<NotifikacijeScreen> createState() => _NotifikacijeScreenState();
}

class _NotifikacijeScreenState extends State<NotifikacijeScreen> {
  final NotifikacijaProvider _provider = NotifikacijaProvider();

  int _currentPage = 0;
  final int _rowsPerPage = 3;
  int _totalCount = 0;

  List<Notifikacija> _notifikacije = [];
  final naslovController = TextEditingController();
  String? _procitanoFilter; // null = sve, "true", "false"

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final filters = {
      'page': _currentPage,
      'pageSize': _rowsPerPage,
      if (naslovController.text.isNotEmpty) 'naslov': naslovController.text,
      if (_procitanoFilter != null) 'procitano': _procitanoFilter,
    };

    final result = await _provider.get(filter: filters);
    setState(() {
      _notifikacije = result.result;
      _totalCount = result.count;
    });
  }

  void _clearFilters() {
    naslovController.clear();
    _procitanoFilter = null;
    _currentPage = 0;
    loadData();
  }

  void _nextPage() {
    if ((_currentPage + 1) * _rowsPerPage >= _totalCount) return;
    setState(() => _currentPage++);
    loadData();
  }

  void _prevPage() {
    if (_currentPage == 0) return;
    setState(() => _currentPage--);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 40.0, top: 20),
      child: Column(
        children: [
          // FILTERI
          Row(
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  controller: naslovController,
                  onChanged: (_) => loadData(),
                  decoration: const InputDecoration(
                    labelText: 'Naslov',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<String>(
                  value: _procitanoFilter,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text("Sve")),
                    DropdownMenuItem(
                      value: "false",
                      child: Text("Nepročitane"),
                    ),
                    DropdownMenuItem(value: "true", child: Text("Pročitane")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _procitanoFilter = value;
                      _currentPage = 0;
                    });
                    loadData();
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Očisti filtere'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // LISTA NOTIFIKACIJA
          Expanded(
            child: ListView.builder(
              itemCount: _notifikacije.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: NotificationCard(notifikacija: _notifikacije[index]),
                );
              },
            ),
          ),

          // PAGINACIJA
          if (_totalCount > _rowsPerPage)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _currentPage == 0 ? null : _prevPage,
                    child: const Text("Prethodna"),
                  ),
                  const SizedBox(width: 16),
                  Text("Stranica ${_currentPage + 1}"),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: (_currentPage + 1) * _rowsPerPage >= _totalCount
                        ? null
                        : _nextPage,
                    child: const Text("Sljedeća"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
