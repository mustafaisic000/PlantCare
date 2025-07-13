class KategorijeTransakcije2025 {
  final int kategorijaTransakcije25062025Id;
  final String nazivKategorije;
  final String tip;

  KategorijeTransakcije2025({
    required this.kategorijaTransakcije25062025Id,
    required this.nazivKategorije,
    required this.tip,
  });

  factory KategorijeTransakcije2025.fromJson(Map<String, dynamic> json) {
    return KategorijeTransakcije2025(
      kategorijaTransakcije25062025Id: json['kategorijaTransakcije25062025Id'],
      nazivKategorije: json['nazivKategorije'],
      tip: json['tip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategorijaTransakcije25062025Id': kategorijaTransakcije25062025Id,
      'nazivKategorije': nazivKategorije,
      'tip': tip,
    };
  }
}
