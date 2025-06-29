import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class RecommendedSection extends StatefulWidget {
  final List<Post> posts;

  const RecommendedSection({super.key, required this.posts});

  @override
  State<RecommendedSection> createState() => RecommendedSectionState();
}

class RecommendedSectionState extends State<RecommendedSection> {
  static RecommendedSectionState? instance;
  late List<Post> _posts;
  final PostProvider _postProvider = PostProvider();

  @override
  void initState() {
    super.initState();
    instance = this;
    _posts = List.from(widget.posts);
  }

  /// 🔁 Ova metoda omogućava vanjskim widgetima da osvježe samo preporučene
  Future<void> refreshRecommended() async {
    final user = AuthProvider.korisnik;
    if (user == null) return;

    final noviPreporuceni = await _postProvider.getRecommended(
      user.korisnikId!,
    );
    setState(() {
      _posts = noviPreporuceni;
    });
  }

  @override
  void dispose() {
    if (instance == this) instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_posts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Preporučeno",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              final post = _posts[index];
              return PostCard(
                key: ValueKey(post.postId),
                post: post,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  ).then((_) {
                    refreshRecommended(); // ⚠️ osvježi uvijek
                  });
                },

                onFavoriteToggle: () async {
                  // Ako je dodan u favorite — ukloni iz preporučenih
                  setState(() {
                    _posts.removeWhere((p) => p.postId == post.postId);
                  });

                  // Dodaj novi preporučeni ako postoji
                  final user = AuthProvider.korisnik;
                  if (user != null) {
                    final noviPreporuceni = await _postProvider.getRecommended(
                      user.korisnikId!,
                    );

                    final novi = noviPreporuceni
                        .where((p) => !_posts.any((x) => x.postId == p.postId))
                        .toList();

                    if (novi.isNotEmpty) {
                      setState(() {
                        _posts.add(novi.first);
                      });
                    }
                  }
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }
}
