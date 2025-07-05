import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/komentar_model.dart';
import 'package:plantcare_mobile/providers/komentari_provider.dart';
import 'package:plantcare_mobile/common/widgets/komentar_card.dart';

class KomentariSection extends StatefulWidget {
  final int postId;
  final int postOwnerId;
  const KomentariSection({
    super.key,
    required this.postId,
    required this.postOwnerId,
  });

  @override
  KomentariSectionState createState() => KomentariSectionState();
}

class KomentariSectionState extends State<KomentariSection> {
  final KomentarProvider _komentarProvider = KomentarProvider();
  final ScrollController _scrollController = ScrollController();

  List<Komentar> _komentari = [];
  int _page = 0;
  final int _pageSize = 5;
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKomentari(reset: true);
  }

  Future<void> _loadKomentari({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;
    setState(() => _isLoading = true);

    try {
      final result = await _komentarProvider.getByPostIdPaged(
        widget.postId,
        reset ? 0 : _page,
        _pageSize,
      );

      setState(() {
        if (reset) {
          _komentari = result.result;
          _page = 1;
        } else {
          _komentari.addAll(result.result);
          _page++;
        }

        _hasMore = _komentari.length < result.count;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void addKomentarNaPocetak(Komentar komentar) {
    setState(() {
      _komentari.insert(0, komentar);
    });
  }

  void refreshKomentari() async {
    await _loadKomentari(reset: true);
    if (_scrollController.hasClients) {
      await Future.delayed(Duration(milliseconds: 100));
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Komentari", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        if (_komentari.isEmpty && !_isLoading)
          const Text("Još uvijek nema komentara."),

        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _komentari.length,
          itemBuilder: (context, index) {
            return KomentarCard(
              komentar: _komentari[index],
              postOwnerId: widget.postOwnerId,
              onDelete: refreshKomentari,
            );
          },
        ),

        if (_hasMore)
          Center(
            child: TextButton(
              onPressed: _loadKomentari,
              child: const Text("Prikaži još"),
            ),
          ),
      ],
    );
  }
}
