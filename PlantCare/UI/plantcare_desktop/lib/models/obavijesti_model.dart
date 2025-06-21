class Obavijest {
  final int obavijestId;
  final String naslov;
  final String sadrzaj;
  final DateTime datum;
  final int korisnikId;
  final String korisnickoIme;

  Obavijest({
    required this.obavijestId,
    required this.naslov,
    required this.sadrzaj,
    required this.datum,
    required this.korisnikId,
    required this.korisnickoIme,
  });

  factory Obavijest.fromJson(Map<String, dynamic> json) {
    return Obavijest(
      obavijestId: json['obavijestId'],
      naslov: json['naslov'],
      sadrzaj: json['sadrzaj'],
      datum: DateTime.parse(json['datum']),
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'obavijestId': obavijestId,
      'naslov': naslov,
      'sadrzaj': sadrzaj,
      'datum': datum.toIso8601String(),
      'korisnikId': korisnikId,
      'korisnickoIme': korisnickoIme,
    };
  }
}
