class Lajk {
  final int lajkId;
  final int korisnikId;
  final String korisnickoIme;
  final int postId;
  final String postNaslov;
  final DateTime datum;

  Lajk({
    required this.lajkId,
    required this.korisnikId,
    required this.korisnickoIme,
    required this.postId,
    required this.postNaslov,
    required this.datum,
  });

  factory Lajk.fromJson(Map<String, dynamic> json) {
    return Lajk(
      lajkId: json['lajkId'],
      korisnikId: json['korisnikId'],
      korisnickoIme: json['korisnickoIme'],
      postId: json['postId'],
      postNaslov: json['postNaslov'],
      datum: DateTime.parse(json['datum']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'korisnikId': korisnikId, 'postId': postId};
  }
}
