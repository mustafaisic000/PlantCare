import 'package:flutter/material.dart';
import 'package:plantcare_mobile/models/notifikacija_model.dart';
import 'package:plantcare_mobile/providers/notifikacija_provider.dart';
import 'package:plantcare_mobile/common/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotifikacijaProvider _provider = NotifikacijaProvider();
  List<Notifikacija> _notifications = [];
  bool _isLoading = true;

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final result = await _provider.get();
      setState(() => _notifications = result.result);
    } catch (e) {
      debugPrint("Greška pri učitavanju notifikacija: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteNotification(int id) async {
    try {
      await _provider.delete(id);
      await _loadNotifications();
    } catch (e) {
      debugPrint("Greška pri brisanju: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
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
                  return NotificationCard(
                    notifikacija: notif,
                    onRefresh: _loadNotifications,
                    onDelete: () => _deleteNotification(notif.notifikacijaId),
                  );
                },
              ),
            ),
    );
  }
}
