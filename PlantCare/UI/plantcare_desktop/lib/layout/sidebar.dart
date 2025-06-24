import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/sidebar_menu_item.dart';
import 'package:plantcare_desktop/core/theme.dart';

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
      color: AppTheme.primaryGreen,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'ZeleniKutak',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Meniji koji odgovaraju tačno rutama u main.dart
          SidebarMenuItem(
            label: 'Postovi',
            icon: Icons.local_florist,
            isActive: selected == 'post',
            onTap: () => onItemSelected('post'),
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
            icon: Icons.announcement,
            isActive: selected == 'obavijesti',
            onTap: () => onItemSelected('obavijesti'),
          ),
          SidebarMenuItem(
            label: 'Notifikacije',
            icon: Icons.notifications,
            isActive: selected == 'notifikacije',
            onTap: () => onItemSelected('notifikacije'),
          ),
          SidebarMenuItem(
            label: 'Izvještaji',
            icon: Icons.insert_chart,
            isActive: selected == 'izvjestaji',
            onTap: () => onItemSelected('izvjestaji'),
          ),

          const Spacer(),

          // Logout dugme
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryGreen,
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Potvrda'),
                      content: const Text(
                        'Da li ste sigurni da se želite odjaviti?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Otkaži'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Odjavi se'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    onItemSelected('logout');
                  }
                },

                icon: const Icon(Icons.logout),
                label: const Text("Log out"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
