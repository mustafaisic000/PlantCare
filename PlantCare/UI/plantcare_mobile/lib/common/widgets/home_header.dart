import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final Function(String) onFilterSelected;

  const HomeHeader({
    super.key,
    required this.onNotificationsTap,
    required this.onFilterSelected,
  });

  void _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Odjava"),
        content: const Text("Da li ste sigurni da se želite odjaviti?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text("Otkaži"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text("Odjavi se"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      AuthProvider.logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ime = AuthProvider.korisnik?.ime ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 🍔 Filter meni
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: onFilterSelected,
            itemBuilder: (_) => const [
              PopupMenuItem(value: "Sve", child: Text("Sve")),
              PopupMenuItem(value: "Premium", child: Text("Premium")),
              PopupMenuItem(value: "Standard", child: Text("Standard")),
            ],
          ),

          // 👋 Dobrodošlica
          Expanded(
            child: Text(
              "Dobro došli $ime!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // 🔔 Notifikacije sa crvenim brojačem
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  NotificationListenerMobile.instance.resetUnreadCount();
                  onNotificationsTap();
                },
              ),
              Positioned(
                right: 4,
                top: 4,
                child: AnimatedBuilder(
                  animation: NotificationListenerMobile.instance,
                  builder: (_, __) {
                    final count =
                        NotificationListenerMobile.instance.unreadCount;
                    if (count == 0) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // 🚪 Logout dugme
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }
}
