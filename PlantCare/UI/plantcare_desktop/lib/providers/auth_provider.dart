import 'package:plantcare_desktop/common/services/notification_listener_desktop.dart';
import 'package:plantcare_desktop/models/korisnici_model.dart';
import 'package:flutter/material.dart';

class AuthProvider {
  static String? username;
  static String? password;
  static Korisnik? korisnik;

  static void logout(BuildContext context) {
    username = null;
    password = null;
    korisnik = null;

    Navigator.pushReplacementNamed(context, '/login');
  }

  static void login(String user, String pass, Korisnik loggedInUser) {
    username = user;
    password = pass;
    korisnik = loggedInUser;
    NotificationListenerDesktop.instance.refresh();
  }
}
