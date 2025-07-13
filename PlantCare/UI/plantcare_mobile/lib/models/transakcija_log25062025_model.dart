import "korisnici_model.dart";

class TransakcijaLog25062025 {
  final int transakcijeLog25062025Id;
  final String staraVrijednost;
  final String novaVrijednost;
  final DateTime datumIzmjene;
  final int korisnikId;
  final Korisnik korisnik;

  TransakcijaLog25062025({
    required this.transakcijeLog25062025Id,
    required this.staraVrijednost,
    required this.novaVrijednost,
    required this.datumIzmjene,
    required this.korisnikId,
    required this.korisnik,
  });

  factory TransakcijaLog25062025.fromJson(Map<String, dynamic> json) {
    return TransakcijaLog25062025(
      transakcijeLog25062025Id: json['transakcijeLog25062025Id'],
      staraVrijednost: json['staraVrijednost'],
      novaVrijednost: json['novaVrijednost'],
      datumIzmjene: DateTime.parse(json["datumIzmjene"]),
      korisnikId: json['korisnikId'],
      korisnik: Korisnik.fromJson(json["korisnik"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transakcijeLog25062025Id': transakcijeLog25062025Id,
      'staraVrijednost': staraVrijednost,
      'novaVrijednost': novaVrijednost,
      'datumIzmjene': datumIzmjene.toIso8601String(),
      'korisnikId': korisnikId,
      'korisnik': korisnik.toJson(),
    };
  }
}
