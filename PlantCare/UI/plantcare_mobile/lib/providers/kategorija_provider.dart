import 'package:plantcare_desktop/models/kategorija_model.dart';
import 'base_provider.dart';

class KategorijaProvider extends BaseProvider<Kategorija> {
  KategorijaProvider() : super('Kategorija');

  @override
  Kategorija fromJson(data) {
    return Kategorija.fromJson(data);
  }
}
