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
    var url = "$fullUrl/$id/update-mobile";
    var uri = Uri.parse(url);
    var headers = getHeaders();
    var jsonRequest = jsonEncode(request);

    var response = await http!.patch(
      uri,
      headers: headers,
      body: jsonRequest,
    ); // ← ispravljeno

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception(response.body);
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
      throw Exception(response.body);
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

  Future<Map<String, dynamic>> validateUsernameEmail({
    required String korisnickoIme,
    required String email,
    int? ignoreId,
  }) async {
    final uri = Uri.parse("$fullUrl/validate-username-email");
    final headers = createHeaders();
    final body = jsonEncode({
      "korisnickoIme": korisnickoIme,
      "email": email,
      "ignoreId": ignoreId,
    });

    final response = await http!.post(uri, headers: headers, body: body);

    if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      return {"valid": false, "errors": data["errors"]["userError"]};
    }

    if (isValidResponse(response)) {
      return {"valid": true};
    }

    throw Exception("Validacija nije uspjela");
  }

  Future<Korisnik> promoteToPremium(int korisnikId) async {
    final uri = Uri.parse("$fullUrl/$korisnikId/promote-to-premium");
    final headers = getHeaders();

    final response = await http!.patch(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Greška prilikom promocije korisnika.");
    }
  }

  Future<Korisnik> getById(int id) async {
    final uri = Uri.parse("$fullUrl/$id");
    final headers = getHeaders();

    final response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Greška prilikom dohvaćanja korisnika.");
    }
  }
}
