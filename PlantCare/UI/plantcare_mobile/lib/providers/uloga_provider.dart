import 'package:plantcare_desktop/models/uloga_model.dart';
import 'base_provider.dart';

class UlogaProvider extends BaseProvider<Uloga> {
  UlogaProvider() : super("Uloga");

  @override
  Uloga fromJson(data) => Uloga.fromJson(data);
}
