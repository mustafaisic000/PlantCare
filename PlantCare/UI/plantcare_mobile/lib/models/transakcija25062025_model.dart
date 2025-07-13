import "korisnici_model.dart";
import 'kategorije_transakcije2025_model.dart';

class Transakcija25062025 {
  final int? transakcija25062025Id;
  final int? korisnikId;
  final Korisnik? korisnik;
  final double iznos;
  final DateTime datumTransakcije;
  final String opis;
  final int kategorijaTransakcije25062025Id;
  final KategorijeTransakcije2025? kategorijaTransakcije25062025;
  final String status;

  Transakcija25062025({
    required this.transakcija25062025Id,
    required this.korisnikId,
    required this.korisnik,
    required this.iznos,
    required this.datumTransakcije,
    required this.opis,
    required this.kategorijaTransakcije25062025Id,
    required this.kategorijaTransakcije25062025,
    required this.status,
  });

  factory Transakcija25062025.fromJson(Map<String, dynamic> json) {
    return Transakcija25062025(
      transakcija25062025Id: json['transakcija25062025Id'],
      korisnikId: json['korisnikId'],
      korisnik: json["korisnik"] != null
          ? Korisnik.fromJson(json["korisnik"])
          : null,
      iznos: json['iznos'],
      datumTransakcije: DateTime.parse(json['datumTransakcije']),
      opis: json['opis'],
      kategorijaTransakcije25062025Id: json['kategorijaTransakcije25062025Id'],
      kategorijaTransakcije25062025:
          json["kategorijaTransakcije25062025"] != null
          ? KategorijeTransakcije2025.fromJson(
              json["kategorijaTransakcije25062025"],
            )
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transakcija25062025Id': transakcija25062025Id,
      'korisnikId': korisnikId,
      "korisnik": korisnik?.toJson(),
      'iznos': iznos,
      'datumTransakcije': datumTransakcije.toIso8601String(),
      'opis': opis,
      'kategorijaTransakcije25062025Id': kategorijaTransakcije25062025Id,
      'kategorijaTransakcije25062025': kategorijaTransakcije25062025?.toJson(),
      'status': status,
    };
  }
}
