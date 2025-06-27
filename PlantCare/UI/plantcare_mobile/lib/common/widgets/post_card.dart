import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/models/katalog_post_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

class PostCard extends StatelessWidget {
  final Post? post;
  final KatalogPost? katalogPost;
  final VoidCallback onTap;

  const PostCard({super.key, this.post, this.katalogPost, required this.onTap})
    : assert(
        post != null || katalogPost != null,
        'Either post or katalogPost must be provided',
      );

  @override
  Widget build(BuildContext context) {
    final bool isUser = AuthProvider.korisnik?.ulogaId == 3;
    print('ULOGA: ${AuthProvider.korisnik?.ulogaId}');
    final bool isPremium = post?.premium ?? katalogPost!.premium;
    print('PREMIUM: $isPremium');
    final String naslov = post?.naslov ?? katalogPost!.postNaslov;
    final String? slika = post?.slika ?? katalogPost!.postSlika;

    final bool locked = isUser && isPremium;

    return GestureDetector(
      onTap: locked ? null : onTap,
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
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.favorite_border, color: Colors.white),
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
                onPressed: locked ? null : onTap,
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
