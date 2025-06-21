import 'package:plantcare_desktop/models/notifikacija_model.dart';
import 'base_provider.dart';

class NotifikacijaProvider extends BaseProvider<Notifikacija> {
  NotifikacijaProvider() : super('Notifikacija');

  @override
  Notifikacija fromJson(data) {
    return Notifikacija.fromJson(data);
  }
}
