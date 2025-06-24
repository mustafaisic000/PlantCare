import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'package:plantcare_desktop/providers/util.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';

class NotificationCard extends StatelessWidget {
  final Notifikacija notifikacija;

  const NotificationCard({super.key, required this.notifikacija});

  @override
  Widget build(BuildContext context) {
    final bool isRead = notifikacija.procitano;

    return GestureDetector(
      onTap: () async {
        // Ako nije pročitana, označi kao pročitanu
        if (!isRead) {
          final provider = NotifikacijaProvider();
          await provider.update(notifikacija.notifikacijaId, {
            "procitano": true,
          });

          // Osvježi UI
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Notifikacija označena kao pročitana."),
              ),
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? const Color(0xFFF3F9F2) : const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifikacija.naslov,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(notifikacija.sadrzaj),
                  const SizedBox(height: 12),
                  if (notifikacija.postNaslov != null)
                    Row(
                      children: [
                        const Icon(Icons.article_outlined, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Post: ${notifikacija.postNaslov!}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  if (notifikacija.korisnickoIme != null)
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Korisnik: ${notifikacija.korisnickoIme!}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                formatDateAndHours(notifikacija.datum),
                style: const TextStyle(color: Colors.black45),
              ),
            ),
            if (!isRead)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
