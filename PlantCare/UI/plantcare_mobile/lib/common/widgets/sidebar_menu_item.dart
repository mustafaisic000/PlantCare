import 'package:flutter/material.dart';

class SidebarMenuItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const SidebarMenuItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.white : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white70,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isActive,
      selectedTileColor: Colors.white24,
      hoverColor: Colors.white10,
    );
  }
}
