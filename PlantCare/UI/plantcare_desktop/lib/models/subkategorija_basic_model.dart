class SubkategorijaBasic {
  final int subkategorijaId;
  final String naziv;

  SubkategorijaBasic({required this.subkategorijaId, required this.naziv});

  factory SubkategorijaBasic.fromJson(Map<String, dynamic> json) {
    return SubkategorijaBasic(
      subkategorijaId: json['subkategorijaId'],
      naziv: json['naziv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'subkategorijaId': subkategorijaId, 'naziv': naziv};
  }
}
