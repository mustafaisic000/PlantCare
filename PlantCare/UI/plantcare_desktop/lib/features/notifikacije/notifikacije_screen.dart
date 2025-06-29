import 'package:flutter/material.dart';
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';
import 'package:plantcare_desktop/common/widgets/notification_card.dart';
import 'package:signalr_core/signalr_core.dart';

class NotifikacijeScreen extends StatefulWidget {
  const NotifikacijeScreen({super.key});

  @override
  State<NotifikacijeScreen> createState() => _NotifikacijeScreenState();
}

class _NotifikacijeScreenState extends State<NotifikacijeScreen> {
  final NotifikacijaProvider _provider = NotifikacijaProvider();
  List<Notifikacija> _notifikacije = [];
  late HubConnection _hubConnection;

  @override
  void initState() {
    super.initState();
    loadData();
    _startSignalR();
  }

  Future<void> loadData() async {
    final result = await _provider.get();
    setState(() {
      _notifikacije = result.result;
    });
  }

  Future<void> _startSignalR() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://localhost:6089/signalrHub')
        .build();

    _hubConnection.on('NovaPoruka', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final poruka = arguments.first.toString();

        if (poruka == "Desktop") {
          setState(() async {
            await loadData();
          });
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
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Greška: ${e.toString()}")));
      }
    }
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
          onDelete: () => _deleteNotifikacija(notifikacija.notifikacijaId),
        );
      },
    );
  }
}
