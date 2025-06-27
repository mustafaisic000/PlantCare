import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'base_provider.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider() : super('Kategorija');

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }

  Future<void> delete(int id) async {
    final url = '$fullUrl/$id';
    final headers = createHeaders();

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception(utf8.decode(response.bodyBytes));
    }
  }
}
