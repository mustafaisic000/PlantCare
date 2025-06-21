import 'subkategorija_basic_model.dart';

class Kategorija {
  final int kategorijaId;
  final String naziv;
  final List<SubkategorijaBasic>? subkategorije;

  Kategorija({
    required this.kategorijaId,
    required this.naziv,
    this.subkategorije,
  });

  factory Kategorija.fromJson(Map<String, dynamic> json) {
    return Kategorija(
      kategorijaId: json['kategorijaId'],
      naziv: json['naziv'],
      subkategorije: json['subkategorije'] != null
          ? (json['subkategorije'] as List<dynamic>)
                .map((e) => SubkategorijaBasic.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategorijaId': kategorijaId,
      'naziv': naziv,
      'subkategorije': subkategorije?.map((e) => e.toJson()).toList(),
    };
  }
}
