import 'package:plantcare_mobile/models/finansijski_limit25062025_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';

class FinansijskiLimit25062025Provider
    extends BaseProvider<FinansijskiLimit25062025> {
  FinansijskiLimit25062025Provider() : super("FinansijskiLimit25062025");

  @override
  FinansijskiLimit25062025 fromJson(data) =>
      FinansijskiLimit25062025.fromJson(data);
}
