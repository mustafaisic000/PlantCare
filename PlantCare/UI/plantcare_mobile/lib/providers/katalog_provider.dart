import 'package:plantcare_desktop/models/katalog_model.dart';
import 'base_provider.dart';

class KatalogProvider extends BaseProvider<Katalog> {
  KatalogProvider() : super('Katalog');

  @override
  Katalog fromJson(data) => Katalog.fromJson(data);
}
