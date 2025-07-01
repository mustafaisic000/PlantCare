import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/komentar_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/komentari_provider.dart';

class KomentarCard extends StatelessWidget {
  final Komentar komentar;
  final int postOwnerId;
  final VoidCallback? onDelete;

  const KomentarCard({
    super.key,
    required this.komentar,
    required this.postOwnerId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final korisnik = AuthProvider.korisnik;
    final bool isMyKomentar = korisnik?.korisnikId == komentar.korisnikId;
    final bool isMyPost = korisnik?.korisnikId == postOwnerId;
    final bool canDelete = isMyKomentar || isMyPost;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  komentar.korisnickoIme,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Brisanje komentara"),
                        content: const Text(
                          "Da li ste sigurni da želite obrisati komentar?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Odustani"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("Obriši"),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      try {
                        await KomentarProvider().deleteWithAuth(
                          komentar.komentarId,
                          korisnik!.korisnikId!,
                        );
                        if (onDelete != null) onDelete!();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Greška pri brisanju komentara."),
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
            ],
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
