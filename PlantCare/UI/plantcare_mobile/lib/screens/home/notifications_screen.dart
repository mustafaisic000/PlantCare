import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/notifikacija_model.dart';
import 'package:plantcare_mobile/providers/notifikacija_provider.dart';
import 'package:plantcare_mobile/common/widgets/notification_card.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/common/services/notification_listener_mobile.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotifikacijaProvider _provider = NotifikacijaProvider();
  List<Notifikacija> _notifications = [];
  late HubConnection _hubConnection;
  bool _isLoading = true;

  // za animaciju
  List<bool> _visible = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _startSignalR();
    NotificationListenerMobile.instance.refresh();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _visible = [];
    });

    try {
      final result = await _provider.get(
        filter: {
          'koPrima': 'Mobilna',
          'korisnikId': AuthProvider.korisnik!.korisnikId,
        },
      );

      await Future.delayed(const Duration(milliseconds: 300)); // Delay prikaza

      setState(() {
        _notifications = result.result;
        _visible = List.filled(_notifications.length, false);
      });

      // Animacija: postepeno prikazuj notifikacije
      for (int i = 0; i < _notifications.length; i++) {
        await Future.delayed(const Duration(milliseconds: 80));
        if (mounted) {
          setState(() => _visible[i] = true);
        }
      }
    } catch (e) {
      debugPrint("Greška pri učitavanju notifikacija: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _startSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:6089/signalrHub')
        .withAutomaticReconnect()
        .build();

    _hubConnection.on('NovaPoruka', (arguments) async {
      final poruka = arguments?.first.toString();
      if (poruka == "Mobilna") {
        await _loadNotifications();
      }
    });

    await _hubConnection.start();
  }

  Future<void> _deleteNotification(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Potvrda'),
        content: const Text(
          'Da li ste sigurni da želite obrisati notifikaciju?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Odustani'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Obriši', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _provider.delete(id);
        if (mounted) await _loadNotifications();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Greška: ${e.toString()}")));
      }
    }
  }

  @override
  void dispose() {
    _hubConnection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Notifikacije",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(child: Text("Nemate nijednu notifikaciju."))
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notif = _notifications[index];

                  return AnimatedOpacity(
                    opacity: _visible.length > index && _visible[index]
                        ? 1.0
                        : 0.0,
                    duration: const Duration(milliseconds: 400),
                    child: NotificationCard(
                      notifikacija: notif,
                      onDelete: () => _deleteNotification(notif.notifikacijaId),
                      onRefresh: _loadNotifications,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
