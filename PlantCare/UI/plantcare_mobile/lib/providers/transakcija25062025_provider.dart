import 'dart:convert';

import 'package:plantcare_mobile/models/stat_kategorija_model.dart';
import 'package:plantcare_mobile/models/transakcija25062025_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';

class Transakcija25062025Provider extends BaseProvider<Transakcija25062025> {
  Transakcija25062025Provider() : super("Transakcija25062025");

  @override
  Transakcija25062025 fromJson(data) => Transakcija25062025.fromJson(data);

  Future<List<StatKategorija>> getStat({dynamic filter}) async {
    var url = "$fullUrl/statistika";

    if (filter != null && filter.isNotEmpty) {
      var queryString = getQueryString(filter);
      url = "$fullUrl/statistika?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = getHeaders();

    var response = await http!.get(uri, headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => StatKategorija.fromJson(item)).toList();
    } else {
      throw Exception("Greška prilikom učitvanje stranice");
    }
  }
}
