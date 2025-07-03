import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _selected = "Sve";
  bool? _premium;

  String get selected => _selected;
  bool? get premium => _premium;

  void setFilter(String value) {
    _selected = value;

    switch (value) {
      case "Premium":
        _premium = true;
        break;
      case "Standard":
        _premium = false;
        break;
      default:
        _premium = null;
    }

    notifyListeners();
  }
}
