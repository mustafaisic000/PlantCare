import 'package:flutter/material.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/filter_provider.dart';
import 'package:provider/provider.dart';

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
      AuthProvider.korisnik = null;
      AuthProvider.username = '';
      AuthProvider.password = '';
      NotificationListenerMobile.instance.resetUnreadCount();

      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ime = AuthProvider.korisnik?.ime ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              "Dobro došli $ime!",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<FilterProvider>(
                builder: (context, filterProvider, _) {
                  final selected = filterProvider.selected;

                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.menu),
                    onSelected: (value) {
                      filterProvider.setFilter(value);
                      onFilterSelected(value);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: "Sve",
                        child: Row(
                          children: [
                            if (selected == "Sve")
                              const Icon(Icons.check, size: 16),
                            if (selected == "Sve") const SizedBox(width: 8),
                            const Text("Sve"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "Premium",
                        child: Row(
                          children: [
                            if (selected == "Premium")
                              const Icon(Icons.check, size: 16),
                            if (selected == "Premium") const SizedBox(width: 8),
                            const Text("Premium"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "Standard",
                        child: Row(
                          children: [
                            if (selected == "Standard")
                              const Icon(Icons.check, size: 16),
                            if (selected == "Standard")
                              const SizedBox(width: 8),
                            const Text("Standard"),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {
                          NotificationListenerMobile.instance
                              .resetUnreadCount();
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
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
