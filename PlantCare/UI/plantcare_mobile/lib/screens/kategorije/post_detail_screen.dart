import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/models/komentar_model.dart';
import 'package:plantcare_mobile/models/lajk_model.dart';
import 'package:plantcare_mobile/providers/komentari_provider.dart';
import 'package:plantcare_mobile/providers/lajk_provider.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/common/widgets/like_section.dart';
import 'package:plantcare_mobile/common/widgets/komentari_section.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/screens/dodaj/dodaj_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _postProvider = PostProvider();
  late Post _post;
  final KomentarProvider _komentarProvider = KomentarProvider();
  final TextEditingController _komentarController = TextEditingController();
  final LajkProvider _lajkProvider = LajkProvider();
  final GlobalKey<KomentariSectionState> _komentariKey = GlobalKey();
  Uint8List? _imageBytes;

  List<Komentar> _komentari = [];
  int _brojLajkova = 0;
  int _page = 0;
  final int _pageSize = 5;
  bool _hasMore = true;
  bool _isLoading = false;
  Lajk? _myLajk;

  @override
  void initState() {
    _post = widget.post;
    super.initState();
    _imageBytes = base64Decode(widget.post.slika ?? '');
    _loadKomentari(reset: true);
    _loadLajkInfo();
  }

  Future<void> _loadKomentari({bool reset = false}) async {
    if (_isLoading || (!_hasMore && !reset)) return;
    setState(() => _isLoading = true);

    try {
      final result = await _komentarProvider.getByPostIdPaged(
        widget.post.postId,
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

  Future<void> _loadLajkInfo() async {
    final count = await _lajkProvider.getCountByPostId(widget.post.postId);
    final lajkovi = await _lajkProvider.getByPostAndKorisnik(
      widget.post.postId,
      AuthProvider.korisnik!.korisnikId!,
    );

    setState(() {
      _brojLajkova = count;
      _myLajk = lajkovi.isNotEmpty ? lajkovi.first : null;
    });
  }

  Future<bool> _toggleLajk() async {
    final wasLiked = _myLajk != null;

    try {
      if (wasLiked) {
        await _lajkProvider.deleteWithAuth(
          _myLajk!.lajkId,
          AuthProvider.korisnik!.korisnikId!,
        );
        _myLajk = null;
      } else {
        _myLajk = await _lajkProvider.insert({
          'korisnikId': AuthProvider.korisnik!.korisnikId!,
          'postId': widget.post.postId,
        });
      }

      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Greška pri lajkanju/unlajkanju.")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = AuthProvider.korisnik?.ulogaId == 3;
    final isPremium = _post.premium;
    final locked = isUser && isPremium;

    if (locked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Premium sadržaj'),
            content: const Text(
              'Ovaj sadržaj je dostupan samo za pretplatnike.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Zatvori'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // ovdje možeš prebaciti korisnika na premium ekran ako želiš
                },
                child: const Text('Saznaj više'),
              ),
            ],
          ),
        );
      });

      return const Scaffold();
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _post); // vrati ažurirani post kad klikne nazad
        return false; // spriječi default zatvaranje jer smo ga već zatvorili
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _post.naslov,
            style: const TextStyle(fontSize: 18),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height *
                    0.45, // ~45% visine ekrana
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image, size: 64)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 20, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          _post.korisnickoIme,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                        if (_post.korisnikId ==
                            AuthProvider.korisnik?.korisnikId) ...[
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final updatedPost =
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => DodajPostScreen(
                                            post: widget.post,
                                          ),
                                        ),
                                      );

                                  if (updatedPost is Post) {
                                    final oldSlika = _post.slika ?? '';
                                    final newSlika = updatedPost.slika ?? '';

                                    setState(() {
                                      _post = updatedPost;

                                      if (oldSlika != newSlika) {
                                        _imageBytes = base64Decode(newSlika);
                                      }
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Post uspješno ažuriran.",
                                          ),
                                        ),
                                      );
                                    }

                                    Navigator.of(context).pop(updatedPost);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Potvrda"),
                                      content: const Text(
                                        "Da li ste sigurni da želite obrisati post?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text("Otkaži"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text("Obriši"),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await _postProvider.softDelete(
                                      widget.post.postId,
                                    );
                                    if (context.mounted)
                                      Navigator.pop(context, true);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  LikeSection(
                    liked: _myLajk != null,
                    brojLajkova: _brojLajkova,
                    onToggleLike: () async {
                      final success = await _toggleLajk();
                      if (success) await _loadLajkInfo();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 2),
              Text(_post.sadrzaj),
              const SizedBox(height: 16),
              const Divider(),
              KomentariSection(
                key: _komentariKey,
                postId: _post.postId,
                postOwnerId: widget.post.korisnikId,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            top: 8,
          ),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, setLocalState) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _komentarController,
                        maxLength: 200,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Dodaj komentar...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          counterText: '', // onemogućimo default prikaz
                        ),
                        buildCounter:
                            (
                              BuildContext context, {
                              required int currentLength,
                              required bool isFocused,
                              required int? maxLength,
                            }) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  right: 4,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '$currentLength/200',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: currentLength > 200
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            },
                        onChanged: (_) => setLocalState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed:
                            _komentarController.text.trim().isEmpty ||
                                _komentarController.text.length > 200
                            ? null
                            : () async {
                                final tekst = _komentarController.text.trim();
                                try {
                                  final inserted = await _komentarProvider
                                      .insert({
                                        'sadrzaj': tekst,
                                        'korisnikId':
                                            AuthProvider.korisnik!.korisnikId!,
                                        'postId': widget.post.postId,
                                      });

                                  _komentarController.clear();
                                  FocusScope.of(context).unfocus();
                                  final newKomentar = Komentar(
                                    komentarId: inserted.komentarId,
                                    sadrzaj: inserted.sadrzaj,
                                    datumKreiranja: inserted.datumKreiranja,
                                    korisnikId:
                                        AuthProvider.korisnik!.korisnikId!,
                                    korisnickoIme:
                                        AuthProvider.korisnik!.korisnickoIme,
                                    postNaslov: inserted.postNaslov,
                                    postId: widget.post.postId,
                                  );

                                  _komentariKey.currentState
                                      ?.addKomentarNaPocetak(newKomentar);
                                  setState(() {});
                                } catch (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Greška pri dodavanju komentara.",
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
