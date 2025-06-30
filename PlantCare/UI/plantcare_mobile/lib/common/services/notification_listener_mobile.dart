import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationListenerMobile extends ChangeNotifier {
  static final NotificationListenerMobile instance =
      NotificationListenerMobile._();
  NotificationListenerMobile._();

  late HubConnection _hubConnection;
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  Future<void> init() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl('http://10.0.2.2:6089/signalrHub')
        .withAutomaticReconnect()
        .build();

    _hubConnection.on('NovaPoruka', (args) {
      final message = args?.first.toString();
      if (message == "Mobilna") {
        _unreadCount++;
        notifyListeners();
      }
    });

    await _hubConnection.start();
  }

  void resetUnreadCount() {
    _unreadCount = 0;
    notifyListeners();
  }
}
