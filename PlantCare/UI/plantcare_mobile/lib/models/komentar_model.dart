class Komentar {
  final int komentarId;
  final String sadrzaj;
  final DateTime datumKreiranja;
  final int korisnikId;
  final String korisnickoIme;
  final String postNaslov;
  final int postId; // <-- dodaj ovo

  Komentar({
    required this.komentarId,
    required this.sadrzaj,
    required this.datumKreiranja,
    required this.korisnikId,
    required this.korisnickoIme,
    required this.postNaslov,
    required this.postId, // <-- i ovdje
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      komentarId: json['komentarId'] ?? 0,
      sadrzaj: json['sadrzaj'] ?? '',
      datumKreiranja: json['datumKreiranja'] != null
          ? DateTime.parse(json['datumKreiranja'])
          : DateTime.now(),
      korisnikId: json['korisnikId'] ?? 0,
      korisnickoIme: json['korisnickoIme'] ?? '',
      postNaslov: json['postNaslov'] ?? '',
      postId: json['postId'] ?? 0, // <-- ovdje
    );
  }

  Map<String, dynamic> toJson() {
    return {'sadrzaj': sadrzaj, 'korisnikId': korisnikId, 'postId': postId};
  }
}
