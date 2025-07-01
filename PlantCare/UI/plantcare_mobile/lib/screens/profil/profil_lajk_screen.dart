import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/lajk_model.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/lajk_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class ProfilLajkoviPostScreen extends StatefulWidget {
  const ProfilLajkoviPostScreen({super.key});

  @override
  State<ProfilLajkoviPostScreen> createState() =>
      _ProfilLajkoviPostScreenState();
}

class _ProfilLajkoviPostScreenState extends State<ProfilLajkoviPostScreen> {
  final LajkProvider _lajkProvider = LajkProvider();
  final PostProvider _postProvider = PostProvider();

  List<Post> _posts = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLikedPosts();
  }

  Future<void> _fetchLikedPosts() async {
    setState(() => _isLoading = true);
    final userId = AuthProvider.korisnik?.korisnikId;
    if (userId == null) return;

    try {
      final result = await _lajkProvider.get(filter: {'KorisnikId': userId});

      final List<Post> likedPosts = [];
      for (Lajk lajk in result.result) {
        final post = await _postProvider.getById(lajk.postId);
        if (_searchText.isEmpty ||
            post.naslov.toLowerCase().contains(_searchText.toLowerCase())) {
          likedPosts.add(post);
        }
      }

      setState(() {
        _posts = likedPosts;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Greška pri dohvaćanju lajkova: $e");
      setState(() => _isLoading = false);
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchText = value;
    });
    _fetchLikedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lajkovani postovi"),
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
                ? const Center(child: Text("Nema lajkovanih postova."))
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
                          _fetchLikedPosts(); // refresh
                        },
                        onFavoriteToggle: _fetchLikedPosts,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
