class Post {
  final int postId;
  final String naslov;
  final String sadrzaj;
  final String? slika;
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
    this.slika,
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
      slika: json['slika'],
      datumKreiranja: DateTime.parse(json['datumKreiranja']),
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'] ?? '',
      premium: json['premium'],
      subkategorijaId: json['subkategorijaId'],
      subkategorijaNaziv: json['subkategorija']?['naziv'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'naslov': naslov,
      'sadrzaj': sadrzaj,
      'slika': slika,
      'datumKreiranja': datumKreiranja.toIso8601String(),
      'korisnikId': korisnikId,
      'korisnickoIme': korisnickoIme,
      'premium': premium,
      'subkategorijaId': subkategorijaId,
      'subkategorijaNaziv': subkategorijaNaziv,
    };
  }
}
