import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'package:plantcare_desktop/providers/util.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';

class NotificationCard extends StatefulWidget {
  final Notifikacija notifikacija;
  final VoidCallback? onRefresh;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notifikacija,
    this.onRefresh,
    this.onDelete,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late bool isRead;

  @override
  void initState() {
    super.initState();
    isRead = widget.notifikacija.procitano;
  }

  Future<void> markAsRead() async {
    if (!isRead) {
      try {
        final provider = NotifikacijaProvider();
        await provider.markAsRead(widget.notifikacija.notifikacijaId);
        setState(() => isRead = true);
        widget.onRefresh?.call();
      } catch (_) {
        // silent fail
      }
    }
  }

  void showDetailsPopup() async {
    await markAsRead();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(widget.notifikacija.naslov),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.notifikacija.sadrzaj),
            const SizedBox(height: 16),
            if (widget.notifikacija.korisnickoIme != null)
              Text("Korisnik: ${widget.notifikacija.korisnickoIme!}"),
            const SizedBox(height: 10),
            Text("Vrijeme: ${formatDateAndHours(widget.notifikacija.datum)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Zatvori"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDetailsPopup,
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFE3F2FD),
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
                    widget.notifikacija.naslov,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.notifikacija.sadrzaj),
                  const SizedBox(height: 12),
                  if (widget.notifikacija.korisnickoIme != null)
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Korisnik: ${widget.notifikacija.korisnickoIme!}",
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatDateAndHours(widget.notifikacija.datum),
                    style: const TextStyle(color: Colors.black45),
                  ),
                  const SizedBox(width: 8),
                  if (widget.onDelete != null)
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: widget.onDelete,
                      tooltip: 'Obriši notifikaciju',
                    ),
                ],
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
                    color: Colors.red,
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
