import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantcare_mobile/models/subkategorije_model.dart';
import 'base_provider.dart';

class SubkategorijaProvider extends BaseProvider<Subkategorija> {
  SubkategorijaProvider() : super('subkategorije');

  @override
  Subkategorija fromJson(data) {
    return Subkategorija.fromJson(data);
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
