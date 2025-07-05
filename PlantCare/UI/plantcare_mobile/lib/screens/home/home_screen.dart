import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/home_header.dart';
import 'package:plantcare_mobile/common/widgets/expandable_section.dart';
import 'package:plantcare_mobile/common/widgets/obavijest_card.dart';
import 'package:plantcare_mobile/common/widgets/katalog_section.dart';
import 'package:plantcare_mobile/common/widgets/recommended_section.dart';
import 'package:plantcare_mobile/models/obavijesti_model.dart';
import 'package:plantcare_mobile/models/katalog_model.dart';
import 'package:plantcare_mobile/providers/obavijest_provider.dart';
import 'package:plantcare_mobile/providers/katalog_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final ObavijestProvider _obavijestProvider = ObavijestProvider();
  final KatalogProvider _katalogProvider = KatalogProvider();

  List<Obavijest> _obavijesti = [];
  List<Katalog> _katalozi = [];
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context)?.isCurrent == true && !_isFirstLoad) {
      loadData();
    }

    _isFirstLoad = false;
  }

  Future<void> loadData() async {
    try {
      final obavijestiResult = await _obavijestProvider.get();
      final katalogResult = await _katalogProvider.get();

      setState(() {
        _obavijesti = obavijestiResult.result;
        _katalozi = katalogResult.result.where((k) => k.aktivan).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
              onFilterSelected: (_) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpandableSection(
                          title: "Obavijesti",
                          children: _obavijesti
                              .where((o) => o.aktivan == true)
                              .map(
                                (o) =>
                                    Center(child: ObavijestCard(obavijest: o)),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        if (_katalozi.isNotEmpty)
                          ExpandableSection(
                            title: "Katalozi",
                            children: _katalozi
                                .map(
                                  (k) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: KatalogSection(katalog: k),
                                  ),
                                )
                                .toList(),
                          ),
                        const SizedBox(height: 24),
                        const RecommendedSection(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
