class Notifikacija {
  final int notifikacijaId;
  final String naslov;
  final String sadrzaj;
  final DateTime datum;
  final int korisnikId;
  final String? korisnickoIme;
  final int? postId;
  final String? postNaslov;
  final bool procitano;

  Notifikacija({
    required this.notifikacijaId,
    required this.naslov,
    required this.sadrzaj,
    required this.datum,
    required this.korisnikId,
    this.korisnickoIme,
    this.postId,
    this.postNaslov,
    required this.procitano,
  });

  factory Notifikacija.fromJson(Map<String, dynamic> json) {
    return Notifikacija(
      notifikacijaId: json['notifikacijaId'],
      naslov: json['naslov'],
      sadrzaj: json['sadrzaj'],
      datum: DateTime.parse(json['datum']),
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'],
      postId: json['postId'],
      postNaslov: json['postNaslov'],
      procitano: json['procitano'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifikacijaId': notifikacijaId,
      'naslov': naslov,
      'sadrzaj': sadrzaj,
      'datum': datum.toIso8601String(),
      'korisnikId': korisnikId,
      'korisnickoIme': korisnickoIme,
      'procitano': procitano,
    };
  }
}
