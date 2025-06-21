class Korisnik {
  final int korisnikId;
  final String ime;
  final String prezime;
  final DateTime? datumRodjenja;
  final String? email;
  final String? telefon;
  final String korisnickoIme;
  final bool status;
  final int ulogaId;
  final String ulogaNaziv;
  final String? slika;

  Korisnik({
    required this.korisnikId,
    required this.ime,
    required this.prezime,
    this.datumRodjenja,
    this.email,
    this.telefon,
    required this.korisnickoIme,
    required this.status,
    required this.ulogaId,
    required this.ulogaNaziv,
    this.slika,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) {
    return Korisnik(
      korisnikId: json['korisnikId'],
      ime: json['ime'],
      prezime: json['prezime'],
      datumRodjenja: json['datumRodjenja'] != null
          ? DateTime.parse(json['datumRodjenja'])
          : null,
      email: json['email'],
      telefon: json['telefon'],
      korisnickoIme: json['korisnickoIme'],
      status: json['status'],
      ulogaId: json['ulogaId'],
      ulogaNaziv: json['ulogaNaziv'],
      slika: json['slika'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'korisnikId': korisnikId,
      'ime': ime,
      'prezime': prezime,
      'datumRodjenja': datumRodjenja?.toIso8601String(),
      'email': email,
      'telefon': telefon,
      'korisnickoIme': korisnickoIme,
      'status': status,
      'ulogaId': ulogaId,
      'ulogaNaziv': ulogaNaziv,
      'slika': slika,
    };
  }
}
