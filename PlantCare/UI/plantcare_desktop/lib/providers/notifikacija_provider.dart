import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'base_provider.dart';

class NotifikacijaProvider extends BaseProvider<Notifikacija> {
  NotifikacijaProvider() : super('Notifikacija');

  @override
  Notifikacija fromJson(data) {
    return Notifikacija.fromJson(data);
  }

  Future<void> delete(int id) async {
    final url = '$fullUrl/$id';
    final headers = createHeaders();

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }

  Future<void> markAsRead(int id) async {
    final url = '$fullUrl/$id/mark-as-read';
    final headers = createHeaders();

    final response = await http.patch(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }
}
