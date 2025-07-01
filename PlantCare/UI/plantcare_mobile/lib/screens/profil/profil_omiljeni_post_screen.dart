import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/omiljeni_post_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class ProfilOmiljeniPostScreen extends StatefulWidget {
  const ProfilOmiljeniPostScreen({super.key});

  @override
  State<ProfilOmiljeniPostScreen> createState() =>
      _ProfilOmiljeniPostScreenState();
}

class _ProfilOmiljeniPostScreenState extends State<ProfilOmiljeniPostScreen> {
  final OmiljeniPostProvider _omiljeniProvider = OmiljeniPostProvider();
  final PostProvider _postProvider = PostProvider();

  List<Post> _posts = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    setState(() => _isLoading = true);
    final userId = AuthProvider.korisnik?.korisnikId;
    if (userId == null) return;

    try {
      final favs = await _omiljeniProvider.get(filter: {'KorisnikId': userId});

      final allPostIds = favs.result.map((e) => e.postId).toList();
      final allPosts = <Post>[];

      // FTS filter se primjenjuje ručno nakon fetcha
      for (int postId in allPostIds) {
        final post = await _postProvider.getById(postId);
        if (_searchText.isEmpty ||
            post.naslov.toLowerCase().contains(_searchText.toLowerCase())) {
          allPosts.add(post);
        }
      }

      setState(() {
        _posts = allPosts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Greška: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchText = value;
    });
    _fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omiljeni postovi'),
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
                ? const Center(child: Text("Nema omiljenih postova."))
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
                          _fetchFavorites();
                        },
                        onFavoriteToggle: _fetchFavorites,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
