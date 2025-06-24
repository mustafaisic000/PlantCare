import 'package:plantcare_desktop/models/post_model.dart';
import 'base_provider.dart';

class PostProvider extends BaseProvider<Post> {
  PostProvider() : super('Post');

  @override
  Post fromJson(data) {
    return Post.fromJson(data);
  }
}
