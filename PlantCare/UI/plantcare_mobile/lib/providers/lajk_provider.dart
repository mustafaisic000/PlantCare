import '../models/lajk_model.dart';
import 'base_provider.dart';

class LajkProvider extends BaseProvider<Lajk> {
  LajkProvider() : super('lajk');

  @override
  Lajk fromJson(data) => Lajk.fromJson(data);

  Future<int> getCountByPostId(int postId) async {
    var url = '$fullUrl/count/post/$postId';
    var headers = getHeaders();
    var response = await http!.get(Uri.parse(url), headers: headers);

    if (isValidResponse(response)) {
      return int.parse(response.body);
    } else {
      throw Exception('Greška prilikom dohvatanja broja lajkova.');
    }
  }

  Future<void> deleteWithAuth(int lajkId, int korisnikId) async {
    var url = '$fullUrl/$lajkId/korisnik/$korisnikId';
    var headers = getHeaders();
    var response = await http!.delete(Uri.parse(url), headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Nemate pravo da obrišete ovaj lajk.');
    }
  }

  Future<List<Lajk>> getByPostAndKorisnik(int postId, int korisnikId) async {
    final headers = getHeaders();
    final url = Uri.parse('$fullUrl?PostId=$postId&KorisnikId=$korisnikId');

    final response = await http!.get(url, headers: headers);

    if (!isValidResponse(response)) {
      throw Exception('Greška pri dohvatu lajka.');
    }

    final data = super.decodeResponse(response);
    return (data['resultList'] as List).map((e) => fromJson(e)).toList();
  }
}
