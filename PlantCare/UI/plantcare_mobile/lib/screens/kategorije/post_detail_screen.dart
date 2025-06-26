import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/models/komentar_model.dart';
import 'package:plantcare_mobile/providers/komentar_provider.dart';
import 'package:plantcare_mobile/providers/lajk_provider.dart';
import 'package:plantcare_mobile/providers/util.dart';
import 'package:plantcare_mobile/common/widgets/komentar_card.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final KomentarProvider _komentarProvider = KomentarProvider();
  final LajkProvider _lajkProvider = LajkProvider();

  List<Komentar> _komentari = [];
  int _brojLajkova = 0;
  final TextEditingController _komentarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKomentari();
    _loadBrojLajkova();
  }

  Future<void> _loadKomentari() async {
    final data = await _komentarProvider.getByPostId(widget.post.postId);
    setState(() {
      _komentari = data;
    });
  }

  Future<void> _loadBrojLajkova() async {
    final count = await _lajkProvider.getCountByPostId(widget.post.postId);
    setState(() {
      _brojLajkova = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isUser = AuthProvider.korisnik?.ulogaId == 3;
    final isPremium = widget.post.premium;
    final locked = isUser && isPremium;

    return Scaffold(
      appBar: AppBar(title: Text(widget.post.naslov)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageFromString(widget.post.slika ?? ''),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  widget.post.korisnickoIme,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.favorite_border),
                const SizedBox(width: 4),
                Text('$_brojLajkova likes'),
              ],
            ),
            const SizedBox(height: 8),

            if (locked)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Ovaj sadržaj je dostupan samo pretplatnicima.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // ovdje kasnije ide navigacija ka premium
                    },
                    child: const Text("Saznaj više o pretplati"),
                  ),
                ],
              )
            else ...[
              Text(widget.post.sadrzaj),
              const SizedBox(height: 16),
              const Divider(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Komentari",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              for (var komentar in _komentari) KomentarCard(komentar: komentar),
              const SizedBox(height: 16),
              TextField(
                controller: _komentarController,
                decoration: InputDecoration(
                  hintText: 'Dodaj komentar...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _dodajKomentar,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _dodajKomentar() async {
    final tekst = _komentarController.text.trim();
    if (tekst.isEmpty) return;

    try {
      await _komentarProvider.insert({
        'sadrzaj': tekst,
        'korisnikId': AuthProvider.korisnik?.korisnikId,
        'postId': widget.post.postId,
      });

      if (!mounted) return;

      _komentarController.clear();
      await _loadKomentari();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Greška pri dodavanju komentara.")),
      );
    }
  }
}
