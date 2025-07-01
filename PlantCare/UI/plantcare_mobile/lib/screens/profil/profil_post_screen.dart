import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class ProfilPostScreen extends StatefulWidget {
  const ProfilPostScreen({super.key});

  @override
  State<ProfilPostScreen> createState() => _ProfilPostScreenState();
}

class _ProfilPostScreenState extends State<ProfilPostScreen> {
  final PostProvider _postProvider = PostProvider();
  List<Post> _posts = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);

    final korisnikId = AuthProvider.korisnik?.korisnikId;
    if (korisnikId == null) return;

    try {
      final result = await _postProvider.get(
        filter: {
          'KorisnikId': korisnikId,
          if (_searchText.isNotEmpty) 'FTS': _searchText,
        },
      );

      setState(() {
        _posts = result.result;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Greška: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onSearch(String value) {
    setState(() => _searchText = value);
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moji postovi"),
        backgroundColor: const Color(0xFF50C878),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Pretraži po naslovu...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _posts.isEmpty
                ? const Center(child: Text("Nema objavljenih postova."))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _posts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.72,
                        ),
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return PostCard(
                        post: post,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailScreen(post: post),
                            ),
                          );
                          _loadPosts();
                        },
                        onFavoriteToggle: _loadPosts,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
