import 'katalog_post_model.dart';

class Katalog {
  int katalogId;
  String naslov;
  String? opis;
  bool aktivan;
  String korisnickoIme;

  List<KatalogPost> katalogPostovi; // <- OVO DODAJ

  Katalog({
    required this.katalogId,
    required this.naslov,
    this.opis,
    required this.aktivan,
    required this.korisnickoIme,
    this.katalogPostovi = const [],
  });

  factory Katalog.fromJson(Map<String, dynamic> json) {
    return Katalog(
      katalogId: json['katalogId'],
      naslov: json['naslov'],
      opis: json['opis'],
      aktivan: json['aktivan'],
      korisnickoIme: json['korisnickoIme'],
      katalogPostovi:
          (json['katalogPostovi'] as List<dynamic>?)
              ?.map((e) => KatalogPost.fromJson(e))
              .toList() ??
          [],
    );
  }
}
