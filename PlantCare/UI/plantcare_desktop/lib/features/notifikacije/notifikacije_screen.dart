import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';
import 'package:plantcare_desktop/common/widgets/notification_card.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:plantcare_desktop/common/services/notification_listener_desktop.dart';

class NotifikacijeScreen extends StatefulWidget {
  const NotifikacijeScreen({super.key});

  @override
  State<NotifikacijeScreen> createState() => _NotifikacijeScreenState();
}

class _NotifikacijeScreenState extends State<NotifikacijeScreen> {
  final NotifikacijaProvider _provider = NotifikacijaProvider();
  List<Notifikacija> _notifikacije = [];
  late HubConnection _hubConnection;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
    _startSignalR();
  }

  Future<void> loadData() async {
    if (_isLoading) return;
    _isLoading = true;

    final result = await _provider.get(filter: {'koPrima': 'Desktop'});

    if (!mounted) return;

    setState(() {
      _notifikacije = result.result;
    });

    _isLoading = false;
  }

  Future<void> _startSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://localhost:6089/signalrHub')
        .withAutomaticReconnect()
        .build();

    _hubConnection.on('NovaPoruka', (arguments) async {
      if (arguments != null && arguments.isNotEmpty) {
        final poruka = arguments.first.toString();

        if (poruka == "Desktop") {
          // 🕒 Kratko čekanje kako bi backend završio upis
          await Future.delayed(const Duration(milliseconds: 300));
          await loadData();
          await NotificationListenerDesktop.instance.refresh();
        }
      }
    });

    await _hubConnection.start();
  }

  Future<void> _deleteNotifikacija(int id) async {
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
            child: const Text('Obriši'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _provider.delete(id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Notifikacija obrisana.")));
        await loadData();
        await NotificationListenerDesktop.instance.refresh();
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _notifikacije.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final notifikacija = _notifikacije[index];
        return NotificationCard(
          notifikacija: notifikacija,
          onRefresh: loadData,
          onDelete: () => _deleteNotifikacija(notifikacija.notifikacijaId),
        );
      },
    );
  }
}
