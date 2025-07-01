import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/notifikacija_model.dart';
import 'package:plantcare_mobile/providers/util.dart';
import 'package:plantcare_mobile/providers/notifikacija_provider.dart';

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
        if (!mounted) return;
        setState(() => isRead = true);
        widget.onRefresh?.call();
      } catch (_) {}
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
          if (widget.onDelete != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete?.call();
              },
              child: const Text("Obriši", style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.notifikacija.notifikacijaId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      confirmDismiss: (_) async {
        widget.onDelete?.call();
        return true;
      },

      onDismissed: (_) {
        widget.onDelete?.call();
      },
      child: GestureDetector(
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
                padding: const EdgeInsets.only(right: 16),
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
                child: Text(
                  formatDateAndHours(widget.notifikacija.datum),
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
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
