class FinansijskiLimit25062025 {
  final int finansijskiLimit25062025Id;
  final int korisnikId;
  final int kategorijaTransakcije25062025Id;
  final int limit;

  FinansijskiLimit25062025({
    required this.finansijskiLimit25062025Id,
    required this.korisnikId,
    required this.kategorijaTransakcije25062025Id,
    required this.limit,
  });

  factory FinansijskiLimit25062025.fromJson(Map<String, dynamic> json) {
    return FinansijskiLimit25062025(
      finansijskiLimit25062025Id: json['finansijskiLimit25062025Id'],
      korisnikId: json['korisnikId'],
      kategorijaTransakcije25062025Id: json['kategorijaTransakcije25062025Id'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finansijskiLimit25062025Id': finansijskiLimit25062025Id,
      'korisnikId': korisnikId,
      'kategorijaTransakcije25062025Id': kategorijaTransakcije25062025Id,
      'limit': limit,
    };
  }
}
