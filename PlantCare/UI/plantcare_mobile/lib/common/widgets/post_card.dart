import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/widgets/stripe_payment_widget.dart';
import 'package:plantcare_mobile/models/katalog_post_model.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/omiljeni_post_provider.dart';
import 'package:plantcare_mobile/common/widgets/recommended_section.dart';

class PostCard extends StatefulWidget {
  final Post? post;
  final KatalogPost? katalogPost;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onSuccess;

  const PostCard({
    super.key,
    this.post,
    this.katalogPost,
    required this.onTap,
    this.onFavoriteToggle,
    this.onSuccess,
  }) : assert(post != null || katalogPost != null);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isFavorite = false;
  int? omiljeniId;

  final omiljeniProvider = OmiljeniPostProvider();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final user = AuthProvider.korisnik;
    final postId = widget.post?.postId ?? widget.katalogPost!.postId;

    if (user != null) {
      final result = await omiljeniProvider.getByPostAndKorisnik(
        postId,
        user.korisnikId!,
      );
      if (result.isNotEmpty) {
        setState(() {
          isFavorite = true;
          omiljeniId = result.first.omiljeniPostId;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final user = AuthProvider.korisnik;
    final postId = widget.post?.postId ?? widget.katalogPost!.postId;

    if (user == null) return;

    if (isFavorite) {
      await omiljeniProvider.deleteById(omiljeniId!);

      setState(() {
        isFavorite = false;
        omiljeniId = null;
      });

      widget.onFavoriteToggle?.call();
      RecommendedSectionState.instance?.refreshRecommended();
    } else {
      final newFav = await omiljeniProvider.insert({
        "postId": postId,
        "korisnikId": user.korisnikId,
      });

      setState(() {
        isFavorite = true;
        omiljeniId = newFav.omiljeniPostId;
      });

      widget.onFavoriteToggle?.call();
      RecommendedSectionState.instance?.refreshRecommended();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUser = AuthProvider.korisnik?.ulogaId == 3;
    final bool isPremium = widget.post?.premium ?? widget.katalogPost!.premium;
    final String naslov = widget.post?.naslov ?? widget.katalogPost!.postNaslov;
    final String? slika = widget.post?.slika ?? widget.katalogPost!.postSlika;

    final bool locked = isUser && isPremium;

    return GestureDetector(
      onTap: locked ? null : widget.onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  slika != null
                      ? Image.memory(
                          base64Decode(slika),
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/no_image.jpg",
                          height: 110,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  if (locked)
                    const Positioned(
                      top: 8,
                      left: 8,
                      child: Icon(Icons.lock, color: Colors.white),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber : Colors.white,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                child: Text(
                  naslov,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: locked
                    ? () {
                        showDialog(
                          context: context,
                          builder: (_) => StripePaymentWidget(
                            onSuccess: () {
                              widget.onSuccess?.call();
                              setState(() {});
                              RecommendedSectionState.instance
                                  ?.refreshRecommended();
                            },
                          ),
                        );
                      }
                    : widget.onTap,

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                child: const Text(
                  "Pogledaj",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
