class Uplata {
  final int uplataId;
  final double iznos;
  final DateTime datum;
  final String tipPretplate;
  final String korisnickoIme;

  Uplata({
    required this.uplataId,
    required this.iznos,
    required this.datum,
    required this.tipPretplate,
    required this.korisnickoIme,
  });

  factory Uplata.fromJson(Map<String, dynamic> json) {
    return Uplata(
      uplataId: json['uplataId'],
      iznos: json['iznos']?.toDouble() ?? 0,
      datum: DateTime.parse(json['datum']),
      tipPretplate: json['tipPretplate'],
      korisnickoIme: json['korisnickoIme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uplataId': uplataId,
      'iznos': iznos,
      'datum': datum.toIso8601String(),
      'tipPretplate': tipPretplate,
      'korisnickoIme': korisnickoIme,
    };
  }
}
