import 'package:plantcare_mobile/models/post_model.dart';
import 'package:plantcare_mobile/models/search_result_model.dart';
import 'base_provider.dart';
import 'dart:convert';

class PostProvider extends BaseProvider<Post> {
  PostProvider() : super('Post');

  @override
  Post fromJson(data) {
    return Post.fromJson(data);
  }

  Future<void> softDelete(int id) async {
    final url = "$fullUrl/$id/soft-delete";
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http!.patch(uri, headers: headers);
    if (!isValidResponse(response)) {
      throw Exception("Greška prilikom deaktivacije posta.");
    }
  }

  @override
  Future<SearchResult<Post>> get({dynamic filter}) async {
    var url = fullUrl!;

    if (filter != null) {
      print("FILTER MAP: $filter"); // <-- DODAJ OVDJE
      var queryString = getQueryString(filter);
      print("POST FILTERS URL: $url?$queryString");
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      print("RAW JSON DATA: $data");

      var result = SearchResult<Post>();
      result.count = data['count'] ?? 0;

      if (data['resultList'] != null) {
        for (var item in data['resultList']) {
          print("Post: ${item['naslov']}");
          result.result.add(Post.fromJson(item));
        }
      }

      print("TOTAL POSTS LOADED: ${result.result.length}");

      return result;
    } else {
      throw Exception("Failed to fetch posts");
    }
  }

  Future<Post> getById(int id) async {
    final uri = Uri.parse("$fullUrl/$id");
    final headers = createHeaders();

    final response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Greška prilikom dohvaćanja posta");
    }
  }
}
