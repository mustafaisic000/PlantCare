class Komentar {
  final int komentarId;
  final String sadrzaj;
  final DateTime datumKreiranja;
  final String korisnickoIme;
  final String postNaslov;

  Komentar({
    required this.komentarId,
    required this.sadrzaj,
    required this.datumKreiranja,
    required this.korisnickoIme,
    required this.postNaslov,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      komentarId: json['komentarId'],
      sadrzaj: json['sadrzaj'],
      datumKreiranja: DateTime.parse(json['datumKreiranja']),
      korisnickoIme: json['korisnickoIme'],
      postNaslov: json['postNaslov'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'sadrzaj': sadrzaj, 'korisnikId': null, 'postId': null};
  }
}
