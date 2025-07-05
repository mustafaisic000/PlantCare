import 'package:flutter/foundation.dart';
import 'package:plantcare_desktop/providers/notifikacija_provider.dart';
import 'package:plantcare_desktop/providers/auth_provider.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationListenerDesktop extends ChangeNotifier {
  static final NotificationListenerDesktop instance =
      NotificationListenerDesktop._internal();
  NotificationListenerDesktop._internal();

  late HubConnection _hubConnection;
  final NotifikacijaProvider _provider = NotifikacijaProvider();
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  Future<void> init() async {
    await refresh();

    _hubConnection = HubConnectionBuilder()
        .withUrl('http://localhost:6089/signalrHub')
        .withAutomaticReconnect()
        .build();

    _hubConnection.on('NovaPoruka', (args) async {
      final msg = args?.first.toString();
      if (msg == "Desktop") {
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
        'koPrima': 'Desktop',
        'procitano': false,
        'korisnikId': korisnikId.toString(),
      },
    );

    _unreadCount = result.result.length;
    notifyListeners();
  }

  void decreaseUnread() {
    if (_unreadCount > 0) {
      _unreadCount--;
      notifyListeners();
    }
  }

  void increaseUnread() {
    _unreadCount++;
    notifyListeners();
  }
}
