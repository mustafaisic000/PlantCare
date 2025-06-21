import 'package:plantcare_desktop/models/obavijesti_model.dart';
import 'base_provider.dart';

class ObavijestProvider extends BaseProvider<Obavijest> {
  ObavijestProvider() : super('Obavijest');

  @override
  Obavijest fromJson(data) {
    return Obavijest.fromJson(data);
  }
}
