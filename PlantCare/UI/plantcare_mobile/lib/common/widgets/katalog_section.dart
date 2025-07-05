import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/katalog_model.dart';
import 'package:plantcare_mobile/common/widgets/post_card.dart';
import 'package:plantcare_mobile/providers/post_provider.dart';
import 'package:plantcare_mobile/screens/kategorije/post_detail_screen.dart';
import 'package:plantcare_mobile/common/widgets/recommended_section.dart';
import 'package:plantcare_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class KatalogSection extends StatefulWidget {
  final Katalog katalog;

  const KatalogSection({super.key, required this.katalog});

  @override
  State<KatalogSection> createState() => _KatalogSectionState();
}

class _KatalogSectionState extends State<KatalogSection> {
  final PostProvider _postProvider = PostProvider();

  @override
  Widget build(BuildContext context) {
    final katalog = widget.katalog;
    final premiumFilter = context.watch<FilterProvider>().premium;

    final filtrirani = katalog.katalogPostovi.where((kp) {
      if (premiumFilter == null) return true;
      return kp.premium == premiumFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          katalog.naslov,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (katalog.opis != null && katalog.opis!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            katalog.opis!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: filtrirani.isEmpty
              ? const Center(child: Text("Nema postova."))
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filtrirani.length,
                  itemBuilder: (context, index) {
                    final katalogPost = filtrirani[index];

                    return PostCard(
                      katalogPost: katalogPost,
                      onTap: () async {
                        final post = await _postProvider.getById(
                          katalogPost.postId,
                        );
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostDetailScreen(post: post),
                          ),
                        );
                        setState(() {});
                        RecommendedSectionState.instance?.refreshRecommended();
                      },
                      onFavoriteToggle: () {
                        RecommendedSectionState.instance?.refreshRecommended();
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
