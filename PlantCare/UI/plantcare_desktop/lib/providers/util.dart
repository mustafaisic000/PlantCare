import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Converts a number to a formatted string, e.g., "1.000,00"
String formatNumber(dynamic value) {
  if (value == null) return "";
  final formatter = NumberFormat(
    '#,##0.00',
    'de_DE',
  ); // Adjust locale if needed
  return formatter.format(value);
}

/// Converts a Base64 string to an [Image] widget
Image imageFromString(String base64String) {
  return Image.memory(base64Decode(base64String), fit: BoxFit.cover);
}

/// Formats a [DateTime] as "dd.MM.yyyy"
String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd.MM.yyyy').format(date);
}

/// Formats a quantity, showing no decimals if it's an integer
String formatQuantity(double quantity) {
  return quantity == quantity.toInt()
      ? quantity.toInt().toString()
      : quantity.toStringAsFixed(1);
}

/// Formats a [DateTime] as "dd.MM.yyyy HH:mm"
String formatDateAndHours(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd.MM.yyyy HH:mm').format(date);
}

DateTime? parseDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return null;
  try {
    return DateFormat('dd.MM.yyyy').parse(dateStr);
  } catch (e) {
    return null;
  }
}
