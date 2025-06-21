import 'katalog_post_model.dart';

class Katalog {
  final int katalogId;
  final String naslov;
  final String? opis;
  final DateTime datumOd;
  final DateTime datumDo;
  final String korisnickoIme;
  final List<KatalogPost> katalogPostovi;

  Katalog({
    required this.katalogId,
    required this.naslov,
    this.opis,
    required this.datumOd,
    required this.datumDo,
    required this.korisnickoIme,
    required this.katalogPostovi,
  });

  factory Katalog.fromJson(Map<String, dynamic> json) {
    return Katalog(
      katalogId: json['katalogId'],
      naslov: json['naslov'],
      opis: json['opis'],
      datumOd: DateTime.parse(json['datumOd']),
      datumDo: DateTime.parse(json['datumDo']),
      korisnickoIme: json['korisnickoIme'],
      katalogPostovi: (json['katalogPostovi'] as List<dynamic>)
          .map((item) => KatalogPost.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'katalogId': katalogId,
      'naslov': naslov,
      'opis': opis,
      'datumOd': datumOd.toIso8601String(),
      'datumDo': datumDo.toIso8601String(),
      'korisnickoIme': korisnickoIme,
      'katalogPostovi': katalogPostovi.map((item) => item.toJson()).toList(),
    };
  }
}
