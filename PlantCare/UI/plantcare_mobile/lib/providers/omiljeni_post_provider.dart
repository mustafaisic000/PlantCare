import 'package:plantcare_mobile/models/omiljeni_post_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';

class OmiljeniPostProvider extends BaseProvider<OmiljeniPost> {
  OmiljeniPostProvider() : super('OmiljeniPost');

  @override
  OmiljeniPost fromJson(data) => OmiljeniPost.fromJson(data);

  Future<void> deleteById(int id) async {
    var url = '$fullUrl/$id';
    var headers = getHeaders();
    var response = await http!.delete(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Brisanje omiljenog posta nije uspjelo.');
    }
  }

  Future<List<OmiljeniPost>> getByPostAndKorisnik(
    int postId,
    int korisnikId,
  ) async {
    final headers = getHeaders();
    final url = Uri.parse('$fullUrl?PostId=$postId&KorisnikId=$korisnikId');

    final response = await http!.get(url, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Greška pri dohvatu omiljenog posta.');
    }

    final data = super.decodeResponse(response);
    return (data['resultList'] as List).map((e) => fromJson(e)).toList();
  }
}
