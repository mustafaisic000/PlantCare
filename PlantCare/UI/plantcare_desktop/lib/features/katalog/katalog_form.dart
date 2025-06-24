import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/katalog_model.dart';
import 'package:plantcare_desktop/models/post_model.dart';
import 'package:plantcare_desktop/providers/katalog_provider.dart';
import 'package:plantcare_desktop/providers/katalog_post_provider.dart';
import 'package:plantcare_desktop/providers/post_provider.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart'; // <-- Dodaj ovo na vrhu

class KatalogForm extends StatefulWidget {
  final Katalog? katalog;
  final VoidCallback onClose;

  const KatalogForm({super.key, this.katalog, required this.onClose});

  @override
  State<KatalogForm> createState() => _KatalogFormState();
}

class _KatalogFormState extends State<KatalogForm> {
  final _formKey = GlobalKey<FormState>();

  final _naslovController = TextEditingController();
  final _opisController = TextEditingController();
  final _searchController = TextEditingController();

  bool _aktivan = true;

  final KatalogProvider _katalogProvider = KatalogProvider();
  final KatalogPostProvider _katalogPostProvider = KatalogPostProvider();
  final PostProvider _postProvider = PostProvider();

  List<Post> _sviPostovi = [];
  List<Post> _filtriraniPostovi = [];
  List<int> _odabraniPostIds = [];

  @override
  void initState() {
    super.initState();
    _loadPostovi();

    if (widget.katalog != null) {
      _naslovController.text = widget.katalog!.naslov;
      _opisController.text = widget.katalog!.opis ?? '';
      _aktivan = widget.katalog!.aktivan;
      _odabraniPostIds = widget.katalog!.katalogPostovi
          .map((kp) => kp.postId)
          .toList();
    }
  }

  Future<void> _loadPostovi() async {
    final result = await _postProvider.get();
    setState(() {
      _sviPostovi = result.result;
      _filtriraniPostovi = _sviPostovi;
    });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_odabraniPostIds.length > 8) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Možete odabrati maksimalno 8 postova.")),
      );
      return;
    }

    final korisnikId = AuthProvider.korisnik?.korisnikId;
    if (korisnikId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Niste logirani.")));
      return;
    }

    final req = {
      "naslov": _naslovController.text,
      "opis": _opisController.text,
      "aktivan": _aktivan,
      "korisnikId": korisnikId,
    };

    try {
      if (widget.katalog == null) {
        final novi = await _katalogProvider.insert(req);
        for (var postId in _odabraniPostIds) {
          await _katalogPostProvider.insert({
            "katalogId": novi.katalogId,
            "postId": postId,
          });
        }
      } else {
        await _katalogProvider.update(widget.katalog!.katalogId, req);
        await _katalogPostProvider.deleteByKatalogId(widget.katalog!.katalogId);
        for (var postId in _odabraniPostIds) {
          await _katalogPostProvider.insert({
            "katalogId": widget.katalog!.katalogId,
            "postId": postId,
          });
        }
      }

      widget.onClose();
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Greška pri spremanju: $e")));
    }
  }

  @override
  void dispose() {
    _naslovController.dispose();
    _opisController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.katalog == null ? "Dodaj katalog" : "Uredi katalog"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _naslovController,
                  decoration: const InputDecoration(labelText: "Naslov"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Unesite naslov" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _opisController,
                  decoration: const InputDecoration(labelText: "Opis"),
                  maxLength: 250,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text("Aktivan"),
                    Switch(
                      value: _aktivan,
                      onChanged: (v) => setState(() => _aktivan = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Odaberite postove (max 8)"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Pretraga postova",
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filtriraniPostovi = _sviPostovi
                          .where(
                            (p) => p.naslov.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _filtriraniPostovi.map((post) {
                        final selected = _odabraniPostIds.contains(post.postId);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(post.naslov),
                              if (post.premium)
                                const Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              if (selected) {
                                _odabraniPostIds.remove(post.postId);
                              } else {
                                if (_odabraniPostIds.length < 8) {
                                  _odabraniPostIds.add(post.postId);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(onPressed: _submit, child: const Text("Sačuvaj")),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Odustani"),
        ),
      ],
    );
  }
}
