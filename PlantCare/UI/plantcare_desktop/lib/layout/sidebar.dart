import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/sidebar_menu_item.dart';

class Sidebar extends StatelessWidget {
  final String selected;
  final Function(String route) onItemSelected;

  const Sidebar({
    required this.selected,
    required this.onItemSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF00C853),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          const Center(
            child: Text(
              'ZeleniKutak',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          const SizedBox(height: 32),
          SidebarMenuItem(
            label: 'Biljke',
            icon: Icons.local_florist,
            isActive: selected == 'biljke',
            onTap: () => onItemSelected('biljke'),
          ),
          SidebarMenuItem(
            label: 'Korisnici',
            icon: Icons.person,
            isActive: selected == 'korisnici',
            onTap: () => onItemSelected('korisnici'),
          ),
          SidebarMenuItem(
            label: 'Kategorije',
            icon: Icons.category,
            isActive: selected == 'kategorije',
            onTap: () => onItemSelected('kategorije'),
          ),
          SidebarMenuItem(
            label: 'Subkategorije',
            icon: Icons.subdirectory_arrow_right,
            isActive: selected == 'subkategorije',
            onTap: () => onItemSelected('subkategorije'),
          ),
          SidebarMenuItem(
            label: 'Katalog',
            icon: Icons.menu_book,
            isActive: selected == 'katalog',
            onTap: () => onItemSelected('katalog'),
          ),
          SidebarMenuItem(
            label: 'Obavijesti',
            icon: Icons.notifications,
            isActive: selected == 'obavijesti',
            onTap: () => onItemSelected('obavijesti'),
          ),
          SidebarMenuItem(
            label: 'Izvještaji',
            icon: Icons.insert_chart,
            isActive: selected == 'izvjestaji',
            onTap: () => onItemSelected('izvjestaji'),
          ),
        ],
      ),
    );
  }
}
