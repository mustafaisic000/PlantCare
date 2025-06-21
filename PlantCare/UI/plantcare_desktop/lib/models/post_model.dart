class Post {
  final int postId;
  final String naslov;
  final String sadrzaj;
  final String? slikaBase64;
  final DateTime datumKreiranja;
  final int korisnikId;
  final String korisnickoIme;
  final bool premium;
  final int subkategorijaId;
  final String subkategorijaNaziv;

  Post({
    required this.postId,
    required this.naslov,
    required this.sadrzaj,
    this.slikaBase64,
    required this.datumKreiranja,
    required this.korisnikId,
    required this.korisnickoIme,
    required this.premium,
    required this.subkategorijaId,
    required this.subkategorijaNaziv,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'],
      naslov: json['naslov'],
      sadrzaj: json['sadrzaj'],
      slikaBase64: json['slika'], // može biti null
      datumKreiranja: DateTime.parse(json['datumKreiranja']),
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'],
      premium: json['premium'],
      subkategorijaId: json['subkategorijaId'],
      subkategorijaNaziv: json['subkategorijaNaziv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'naslov': naslov,
      'sadrzaj': sadrzaj,
      'slika': slikaBase64,
      'datumKreiranja': datumKreiranja.toIso8601String(),
      'korisnikId': korisnikId,
      'korisnickoIme': korisnickoIme,
      'premium': premium,
      'subkategorijaId': subkategorijaId,
      'subkategorijaNaziv': subkategorijaNaziv,
    };
  }
}
