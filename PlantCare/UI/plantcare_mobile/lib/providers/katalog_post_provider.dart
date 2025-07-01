import 'package:plantcare_mobile/models/katalog_post_model.dart';
import 'base_provider.dart';

class KatalogPostProvider extends BaseProvider<KatalogPost> {
  KatalogPostProvider() : super('KatalogPost');

  @override
  KatalogPost fromJson(data) => KatalogPost.fromJson(data);

  Future<void> deleteByKatalogId(int katalogId) async {
    var url = "$fullUrl/ByKatalog/$katalogId";
    var response = await http!.delete(Uri.parse(url), headers: getHeaders());

    if (!isValidResponse(response)) {
      throw Exception(
        'Neuspješno brisanje KatalogPostova za katalog $katalogId',
      );
    }
  }
}
