import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/home_header.dart';
import 'package:plantcare_mobile/models/kategorija_model.dart';
import 'package:plantcare_mobile/providers/kategorija_provider.dart';
import 'package:plantcare_mobile/screens/kategorije/posts_screen.dart'; // <-- Add this import

class KategorijeScreen extends StatefulWidget {
  const KategorijeScreen({super.key});

  @override
  State<KategorijeScreen> createState() => _KategorijeScreenState();
}

class _KategorijeScreenState extends State<KategorijeScreen> {
  final KategorijaProvider _provider = KategorijaProvider();
  final TextEditingController _searchController = TextEditingController();

  List<Kategorija> _kategorije = [];
  List<Kategorija> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadKategorije();
  }

  Future<void> loadKategorije() async {
    final result = await _provider.get();
    setState(() {
      _kategorije = result.result;
      _filtered = _kategorije;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filtered = _kategorije
          .where((k) => k.naziv.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void _openNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: HomeHeader(
              onNotificationsTap: _openNotifications,
              onFilterSelected: (_) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Pretraži kategorije...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 3 / 2,
                        ),
                    itemBuilder: (context, index) {
                      final kategorija = _filtered[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PostsScreen(kategorija: kategorija),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                            border: Border.all(color: Colors.green, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              kategorija.naziv,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
