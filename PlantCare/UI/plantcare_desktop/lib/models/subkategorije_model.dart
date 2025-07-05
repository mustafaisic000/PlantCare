class Subkategorija {
  final int subkategorijaId;
  final String naziv;
  final int kategorijaId;
  final String? kategorijaNaziv;

  Subkategorija({
    required this.subkategorijaId,
    required this.naziv,
    required this.kategorijaId,
    this.kategorijaNaziv,
  });

  factory Subkategorija.fromJson(Map<String, dynamic> json) {
    return Subkategorija(
      subkategorijaId: json['subkategorijaId'],
      naziv: json['naziv'],
      kategorijaId: json['kategorijaId'],
      kategorijaNaziv: json['kategorijaNaziv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subkategorijaId': subkategorijaId,
      'naziv': naziv,
      'kategorijaId': kategorijaId,
      'kategorijaNaziv': kategorijaNaziv,
    };
  }
}
