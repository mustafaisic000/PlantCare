class Uloga {
  final int ulogaId;
  final String naziv;
  final String? opis;

  Uloga({required this.ulogaId, required this.naziv, this.opis});

  factory Uloga.fromJson(Map<String, dynamic> json) {
    return Uloga(
      ulogaId: json['ulogaId'] is int
          ? json['ulogaId']
          : int.parse(json['ulogaId'].toString()),
      naziv: json['naziv'],
      opis: json['opis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'ulogaId': ulogaId, 'naziv': naziv, 'opis': opis};
  }
}
