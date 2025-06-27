import '../models/komentar_model.dart';
import 'base_provider.dart';
import '../models/search_result_model.dart';

class KomentarProvider extends BaseProvider<Komentar> {
  KomentarProvider() : super('komentar');

  @override
  Komentar fromJson(data) => Komentar.fromJson(data);

  Future<void> deleteWithAuth(int komentarId, int korisnikId) async {
    final url = '$fullUrl/$komentarId/korisnik/$korisnikId';
    final headers = getHeaders();
    final response = await http!.delete(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Nemate pravo da obrišete ovaj komentar.');
    }
  }

  Future<List<Komentar>> getByPostId(int postId) async {
    final headers = getHeaders();
    final url = Uri.parse('$fullUrl?PostId=$postId');

    final response = await http!.get(url, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Greška pri dohvatu komentara.');
    }

    final data = super.decodeResponse(response);
    return (data['resultList'] as List).map((e) => fromJson(e)).toList();
  }

  Future<SearchResult<Komentar>> getByPostIdPaged(
    int postId,
    int page,
    int pageSize,
  ) async {
    final headers = getHeaders();
    final url = Uri.parse(
      '$fullUrl?PostId=$postId&page=$page&pageSize=$pageSize',
    );

    final response = await http!.get(url, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Greška pri dohvatu komentara.');
    }

    final data = super.decodeResponse(response);

    return SearchResult<Komentar>()
      ..count = data['count']
      ..result = (data['resultList'] as List).map((e) => fromJson(e)).toList();
  }
}
