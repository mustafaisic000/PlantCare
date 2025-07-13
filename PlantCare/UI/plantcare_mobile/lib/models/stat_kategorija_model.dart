class StatKategorija {
  final String getNaziv;
  final double iznos;

  StatKategorija({required this.getNaziv, required this.iznos});

  factory StatKategorija.fromJson(Map<String, dynamic> json) {
    return StatKategorija(getNaziv: json['getNaziv'], iznos: json['iznos']);
  }

  Map<String, dynamic> toJson() {
    return {'getNaziv': getNaziv, 'iznos': iznos};
  }
}
