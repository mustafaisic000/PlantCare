class Subkategorija {
  final int subkategorijaId;
  final String naziv;
  final int kategorijaId;

  Subkategorija({
    required this.subkategorijaId,
    required this.naziv,
    required this.kategorijaId,
  });

  factory Subkategorija.fromJson(Map<String, dynamic> json) {
    return Subkategorija(
      subkategorijaId: json['subkategorijaId'],
      naziv: json['naziv'],
      kategorijaId: json['kategorijaId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subkategorijaId': subkategorijaId,
      'naziv': naziv,
      'kategorijaId': kategorijaId,
    };
  }
}
