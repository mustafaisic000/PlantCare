import 'package:plantcare_mobile/models/uplata_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';

class UplataProvider extends BaseProvider<Uplata> {
  UplataProvider() : super("Uplata");

  @override
  Uplata fromJson(data) => Uplata.fromJson(data);
}
