import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:plantcare_mobile/models/search_result_model.dart';
import 'package:plantcare_mobile/providers/auth_provider.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";
  String? fullUrl;

  HttpClient client = HttpClient();
  IOClient? http;

  BaseProvider(String endpoint) {
    _baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://10.0.2.2:6089/",
    );
    if (!_baseUrl!.endsWith("/")) {
      _baseUrl = _baseUrl! + "/";
    }

    _endpoint = endpoint;
    client.badCertificateCallback = (cert, host, port) => true;
    http = IOClient(client);
    fullUrl = "$_baseUrl$_endpoint";
  }

  Future<List<T>> getAll([Map<String, dynamic>? search]) async {
    var url = "$_baseUrl$_endpoint";

    if (search != null && search.isNotEmpty) {
      String queryString = getQueryString(search);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = getHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return data.map((x) => fromJson(x)).cast<T>().toList();
      } else {
        throw Exception("Expected a list but got: ${data.runtimeType}");
      }
    } else {
      throw Exception("Failed to load data.");
    }
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<T>();
      result.count = data['count'];
      for (var item in data['resultList']) {
        result.result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Wrong username or password");
    }
  }

  Future<T> insert(dynamic request) async {
    var uri = Uri.parse(fullUrl!);
    var headers = createHeaders();
    var response = await http!.post(
      uri,
      headers: headers,
      body: jsonEncode(request),
    );
    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<List<T>> getAllPaged({int pageSize = 1000}) async {
    final result = await get(filter: {'page': 1, 'pageSize': pageSize});
    return result.result;
  }

  Future<T> update(int id, [dynamic request]) async {
    var uri = Uri.parse("$fullUrl/$id");
    var headers = createHeaders();
    var response = await http!.put(
      uri,
      headers: headers,
      body: jsonEncode(request),
    );
    if (isValidResponse(response)) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Unknown error");
    }
  }

  T fromJson(data);

  bool isValidResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) return true;

    if (statusCode == 401) {
      throw Exception("Unauthorized");
    }

    try {
      print("Error ${statusCode}: ${response.body}");
    } catch (e) {
      print("Error ${statusCode}: Failed to read response body");
    }

    throw Exception("Something went wrong, please try again");
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    return {"Content-Type": "application/json", "Authorization": basicAuth};
  }

  Map<String, String> getHeaders() {
    String username = AuthProvider.username!;
    String password = AuthProvider.password!;
    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";
    return {"Content-Type": "application/json", "Authorization": basicAuth};
  }

  String getQueryString(
    Map params, {
    String prefix = '&',
    bool inRecursion = false,
  }) {
    String query = '';
    params.forEach((key, value) {
      if (value is String || value is int || value is double || value is bool) {
        var encoded = (value is String) ? Uri.encodeComponent(value) : value;
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${value.toIso8601String()}';
      } else if (value is List) {
        for (var v in value) {
          query += '$prefix$key=${Uri.encodeComponent(v.toString())}';
        }
      } else if (value is Map) {
        value.forEach((k, v) {
          query += getQueryString(
            {k: v},
            prefix: '$prefix$key.',
            inRecursion: true,
          );
        });
      }
    });
    return query;
  }
}
