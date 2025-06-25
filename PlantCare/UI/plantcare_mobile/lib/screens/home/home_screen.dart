import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/home_header.dart';
import 'package:plantcare_mobile/common/widgets/expandable_section.dart';
import 'package:plantcare_mobile/common/widgets/obavijest_card.dart';
import 'package:plantcare_mobile/models/obavijesti_model.dart';
import 'package:plantcare_mobile/providers/obavijest_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = "Sve";
  final ObavijestProvider _provider = ObavijestProvider();

  List<Obavijest> _obavijesti = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadObavijesti();
  }

  Future<void> loadObavijesti() async {
    try {
      final result = await _provider.get();
      setState(() {
        _obavijesti = result.result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void handleFilterChange(String value) {
    setState(() => selectedFilter = value);
  }

  void openNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: HomeHeader(
              onNotificationsTap: openNotifications,
              onFilterSelected: handleFilterChange,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ExpandableSection(
                          title: "Obavijesti",
                          children: _obavijesti
                              .map((o) => ObavijestCard(obavijest: o))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        // Ovdje možeš dodati i druge sekcije (npr. Katalog, Preporuke itd.)
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
