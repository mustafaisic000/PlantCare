import 'package:plantcare_desktop/models/post_model.dart';
import 'base_provider.dart';

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
}
