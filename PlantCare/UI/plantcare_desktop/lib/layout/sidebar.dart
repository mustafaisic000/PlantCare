import 'package:flutter/material.dart';
import 'package:plantcare_desktop/common/widgets/sidebar_menu_item.dart';
import 'package:plantcare_desktop/core/theme.dart';
import 'package:signalr_core/signalr_core.dart';

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
  late HubConnection _hubConnection;
  String? latestPoruka;
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _startSignalR();
  }

  Future<void> _startSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://localhost:6089/signalrHub')
        .build();

    _hubConnection.on('NovaPoruka', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final poruka = arguments.first.toString();

        if (poruka == "Desktop") {
          setState(() {
            unreadCount++;
            latestPoruka = poruka;
          });
        }
      }
    });

    await _hubConnection.start();
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

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
          SidebarMenuItem(
            label: unreadCount > 0
                ? 'Notifikacije ($unreadCount)'
                : 'Notifikacije',
            icon: Icons.notifications,
            isActive: widget.selected == 'notifikacije',
            onTap: () {
              setState(() {
                unreadCount = 0;
              });
              widget.onItemSelected('notifikacije');
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
