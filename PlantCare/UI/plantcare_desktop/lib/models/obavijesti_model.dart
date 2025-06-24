class Obavijest {
  final int obavijestId;
  final String naslov;
  final String sadrzaj;
  final bool aktivan;
  final int korisnikId;
  final String korisnickoIme;

  Obavijest({
    required this.obavijestId,
    required this.naslov,
    required this.sadrzaj,
    required this.aktivan,
    required this.korisnikId,
    required this.korisnickoIme,
  });

  factory Obavijest.fromJson(Map<String, dynamic> json) {
    return Obavijest(
      obavijestId: json['obavijestId'],
      naslov: json['naslov'],
      sadrzaj: json['sadrzaj'],
      aktivan: json['aktivan'],
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'obavijestId': obavijestId,
      'naslov': naslov,
      'sadrzaj': sadrzaj,
      'datum': aktivan,
      'korisnikId': korisnikId,
      'korisnickoIme': korisnickoIme,
    };
  }
}
