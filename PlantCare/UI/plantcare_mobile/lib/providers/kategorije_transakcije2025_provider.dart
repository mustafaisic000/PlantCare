import 'package:plantcare_mobile/models/kategorije_transakcije2025_model.dart';
import 'package:plantcare_mobile/providers/base_provider.dart';

class KategorijeTransakcije2025Provider
    extends BaseProvider<KategorijeTransakcije2025> {
  KategorijeTransakcije2025Provider() : super("KategorijaTransakcije25062025");

  @override
  KategorijeTransakcije2025 fromJson(data) =>
      KategorijeTransakcije2025.fromJson(data);
}
