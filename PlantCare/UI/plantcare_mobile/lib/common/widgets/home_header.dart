import 'package:flutter/material.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final Function(String) onFilterSelected;

  const HomeHeader({
    super.key,
    required this.onNotificationsTap,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final ime = AuthProvider.korisnik?.ime ?? "";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 🍔 Burger meni sa popup filterom
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: onFilterSelected,
            itemBuilder: (_) => [
              const PopupMenuItem(value: "Sve", child: Text("Sve")),
              const PopupMenuItem(value: "Premium", child: Text("Premium")),
              const PopupMenuItem(value: "Standard", child: Text("Standard")),
            ],
          ),

          // 👋 Centrirani tekst
          Expanded(
            child: Text(
              "Dobro došli $ime!",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // 🔔 Notifikacije
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: onNotificationsTap,
          ),
        ],
      ),
    );
  }
}
