import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/komentar_model.dart';

class KomentarCard extends StatelessWidget {
  final Komentar komentar;

  const KomentarCard({super.key, required this.komentar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            komentar.korisnickoIme,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            komentar.sadrzaj,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }
}
