class Uplata {
  final int? uplataId;
  final double? iznos;
  final DateTime? datum;
  final String? korisnickoIme;

  Uplata({this.uplataId, this.iznos, this.datum, this.korisnickoIme});

  factory Uplata.fromJson(Map<String, dynamic> json) {
    return Uplata(
      uplataId: json['uplataId'],
      iznos: (json['iznos'] as num?)?.toDouble(),
      datum: json['datum'] != null ? DateTime.tryParse(json['datum']) : null,
      korisnickoIme: json['korisnickoIme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uplataId': uplataId,
      'iznos': iznos,
      'datum': datum?.toIso8601String(),
      'korisnickoIme': korisnickoIme,
    };
  }
}
