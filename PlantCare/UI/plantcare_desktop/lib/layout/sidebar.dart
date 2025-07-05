import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/sidebar_menu_item.dart';
import 'package:plantcare_desktop/core/theme.dart';
import 'package:plantcare_desktop/common/services/notification_listener_desktop.dart';

class Sidebar extends StatefulWidget {
  final String selected;
  final Function(String route) onItemSelected;

  const Sidebar({
    required this.selected,
    required this.onItemSelected,
    super.key,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
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
          SidebarMenuItem(
            label: 'Postovi',
            icon: Icons.local_florist,
            isActive: widget.selected == 'post',
            onTap: () => widget.onItemSelected('post'),
          ),
          SidebarMenuItem(
            label: 'Korisnici',
            icon: Icons.person,
            isActive: widget.selected == 'korisnici',
            onTap: () => widget.onItemSelected('korisnici'),
          ),
          SidebarMenuItem(
            label: 'Kategorije',
            icon: Icons.category,
            isActive: widget.selected == 'kategorije',
            onTap: () => widget.onItemSelected('kategorije'),
          ),
          SidebarMenuItem(
            label: 'Subkategorije',
            icon: Icons.subdirectory_arrow_right,
            isActive: widget.selected == 'subkategorije',
            onTap: () => widget.onItemSelected('subkategorije'),
          ),
          SidebarMenuItem(
            label: 'Katalog',
            icon: Icons.menu_book,
            isActive: widget.selected == 'katalog',
            onTap: () => widget.onItemSelected('katalog'),
          ),
          SidebarMenuItem(
            label: 'Obavijesti',
            icon: Icons.announcement,
            isActive: widget.selected == 'obavijesti',
            onTap: () => widget.onItemSelected('obavijesti'),
          ),
          AnimatedBuilder(
            animation: NotificationListenerDesktop.instance,
            builder: (context, _) {
              final count = NotificationListenerDesktop.instance.unreadCount;
              final label = count > 0
                  ? 'Notifikacije ($count)'
                  : 'Notifikacije';

              return SidebarMenuItem(
                label: label,
                icon: Icons.notifications,
                isActive: widget.selected == 'notifikacije',
                onTap: () {
                  widget.onItemSelected('notifikacije');
                },
              );
            },
          ),
          SidebarMenuItem(
            label: 'Izvještaji',
            icon: Icons.insert_chart,
            isActive: widget.selected == 'izvjestaji',
            onTap: () => widget.onItemSelected('izvjestaji'),
          ),

          const Spacer(),

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
                    widget.onItemSelected('logout');
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
