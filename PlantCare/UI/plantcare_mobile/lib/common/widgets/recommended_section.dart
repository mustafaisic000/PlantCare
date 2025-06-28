import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';

class RecommendedSection extends StatefulWidget {
  const RecommendedSection({super.key});

  @override
  State<RecommendedSection> createState() => _RecommendedSectionState();
}

class _RecommendedSectionState extends State<RecommendedSection> {
  final PostProvider _postProvider = PostProvider();
  List<Post> _recommended = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommended();
  }

  Future<void> _loadRecommended() async {
    try {
      final userId = AuthProvider.korisnik!.korisnikId!;
      final result = await _postProvider.getRecommended(userId);

      setState(() {
        _recommended = result;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recommended.isEmpty) {
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
            itemCount: _recommended.length,
            itemBuilder: (context, index) {
              final post = _recommended[index];
              return PostCard(
                post: post,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: post),
                    ),
                  );

                  if (result == true) {
                    _loadRecommended();
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
