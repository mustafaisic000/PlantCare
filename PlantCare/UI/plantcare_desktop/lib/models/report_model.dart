class Report {
  final int reportId;
  final DateTime datum;
  final String korisnickoIme;
  final int postId;
  final String postNaslov;
  final int brojLajkova;
  final int brojOmiljenih;

  Report({
    required this.reportId,
    required this.datum,
    required this.korisnickoIme,
    required this.postId,
    required this.postNaslov,
    required this.brojLajkova,
    required this.brojOmiljenih,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      datum: DateTime.parse(json['datum']),
      korisnickoIme: json['korisnickoIme'],
      postId: json['postId'],
      postNaslov: json['postNaslov'],
      brojLajkova: json['brojLajkova'],
      brojOmiljenih: json['brojOmiljenih'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'datum': datum.toIso8601String(),
      'korisnickoIme': korisnickoIme,
      'postId': postId,
      'postNaslov': postNaslov,
      'brojLajkova': brojLajkova,
      'brojOmiljenih': brojOmiljenih,
    };
  }
}
