import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/filter_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';
import 'package:provider/provider.dart';

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => RecommendedSectionState();
}

class RecommendedSectionState extends State<RecommendedSection> {
  static RecommendedSectionState? instance;
  final PostProvider _postProvider = PostProvider();
  List<Post> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    instance = this;
    loadRecommended();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<FilterProvider>().addListener(_onFilterChanged);
  }

  void _onFilterChanged() {
    refreshRecommended(); // reaguje kad se filter promijeni
  }

  Future<void> loadRecommended() async {
    await refreshRecommended();
  }

  Future<void> refreshRecommended({bool refill = false}) async {
    final user = AuthProvider.korisnik;
    if (user == null) return;

    final filter = context.read<FilterProvider>();
    final noviPreporuceni = await _postProvider.getRecommended(
      user.korisnikId!,
      premium: filter.premium,
    );

    if (refill) {
      final novi = noviPreporuceni
          .where((p) => !_posts.any((x) => x.postId == p.postId))
          .toList();

      if (novi.isNotEmpty) {
        setState(() {
          _posts.add(novi.first);
        });
      }
    } else {
      setState(() {
        _posts = noviPreporuceni;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    context.read<FilterProvider>().removeListener(_onFilterChanged);
    if (instance == this) instance = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  );
                  refreshRecommended();
                },
                onFavoriteToggle: () async {
                  setState(() {
                    _posts.removeWhere((p) => p.postId == post.postId);
                  });
                  await refreshRecommended(refill: true);
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
