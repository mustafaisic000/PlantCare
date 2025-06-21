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
}
