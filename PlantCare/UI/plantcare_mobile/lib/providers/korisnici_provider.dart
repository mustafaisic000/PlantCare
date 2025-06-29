import 'dart:convert';
import 'package:plantcare_mobile/models/korisnici_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnik");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future<Korisnik> authenticate() async {
    var url = "$fullUrl/Authenticate";
    var uri = Uri.parse(url);
    var headers = getHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var korisnik = fromJson(data);
      AuthProvider.korisnik = korisnik;
      notifyListeners();
      return korisnik;
    } else {
      throw Exception("Wrong username or password");
    }
  }

  Future<void> softDelete(int id) async {
    final url = "$fullUrl/$id/soft-delete";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http!.patch(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception("Greška prilikom deaktivacije korisnika.");
    }
  }

  Future<void> resetPassword(int? id) async {
    var url = "$fullUrl/$id/ResetPassword";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.post(uri, headers: headers);
    if (isValidResponse(response)) {
      print("Lozinka promijenjena.");
    } else {
      throw Exception("Neuspješno mijenjanje lozinke.");
    }
  }

  Future<Korisnik> updateMobile(int id, Map<String, dynamic> request) async {
    var url = "$fullUrl/$id/UpdateMobile";
    var uri = Uri.parse(url);
    var headers = getHeaders();
    var jsonRequest = jsonEncode(request);

    var response = await http!.put(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to update mobile: ${response.statusCode}");
    }
  }

  Future<Korisnik> updateKorisnik(Korisnik korisnik) async {
    var url = "$fullUrl/${korisnik.korisnikId}";
    var uri = Uri.parse(url);
    var headers = getHeaders();
    var jsonRequest = jsonEncode(korisnik.toJson());

    var response = await http!.put(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Greška prilikom ažuriranja korisnika.");
    }
  }

  Future<void> insertKorisnik(Map<String, dynamic> request) async {
    var uri = Uri.parse(fullUrl!);
    var headers = {"Content-Type": "application/json"};
    var jsonRequest = jsonEncode(request);

    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (!isValidResponse(response)) {
      throw Exception("Greška prilikom dodavanja korisnika.");
    }
  }

  Future<void> resetPasswordByEmail(String email) async {
    final url = "$fullUrl/reset-password-by-email";
    final uri = Uri.parse(url);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(email);

    final response = await http!.post(uri, headers: headers, body: body);

    if (!isValidResponse(response)) {
      throw Exception("Reset failed: ${response.statusCode}");
    }
  }
}
