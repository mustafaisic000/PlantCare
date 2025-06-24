import 'package:plantcare_desktop/models/subkategorije_model.dart';
import 'base_provider.dart';

class SubkategorijaProvider extends BaseProvider<Subkategorija> {
  SubkategorijaProvider() : super('subkategorije');

  @override
  Subkategorija fromJson(data) {
    return Subkategorija.fromJson(data);
  }
}
