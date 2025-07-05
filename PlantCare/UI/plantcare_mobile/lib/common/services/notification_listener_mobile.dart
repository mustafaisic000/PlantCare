import 'package:flutter/foundation.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';
import 'package:plantcare_mobile/providers/notifikacija_provider.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationListenerMobile extends ChangeNotifier {
  static final NotificationListenerMobile instance =
      NotificationListenerMobile._();
  NotificationListenerMobile._();

  late HubConnection _hubConnection;
  int _unreadCount = 0;
  final NotifikacijaProvider _provider = NotifikacijaProvider();

  int get unreadCount => _unreadCount;

  Future<void> init() async {
    await refresh();

    _hubConnection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:6089/signalrHub')
        .withAutomaticReconnect()
        .build();

    _hubConnection.on('NovaPoruka', (args) async {
      final message = args?.first.toString();
      if (message == "Mobilna") {
        await refresh();
      }
    });

    await _hubConnection.start();
  }

  Future<void> refresh() async {
    final korisnikId = AuthProvider.korisnik?.korisnikId;
    if (korisnikId == null) return;

    final result = await _provider.get(
      filter: {
        'koPrima': 'Mobilna',
        'korisnikId': korisnikId,
        'procitano': false,
      },
    );

    _unreadCount = result.result.length;
    notifyListeners();
  }

  void resetUnreadCount() {
    _unreadCount = 0;
    notifyListeners();
  }
}
