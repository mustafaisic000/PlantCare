class OmiljeniPost {
  int? omiljeniPostId;
  int korisnikId;
  int postId;
  String? korisnickoIme;
  String? postNaslov;

  OmiljeniPost({
    this.omiljeniPostId,
    required this.korisnikId,
    required this.postId,
    this.korisnickoIme,
    this.postNaslov,
  });

  factory OmiljeniPost.fromJson(Map<String, dynamic> json) {
    return OmiljeniPost(
      omiljeniPostId: json['omiljeniPostId'],
      korisnikId: json['korisnikId'],
      postId: json['postId'],
      korisnickoIme: json['korisnickoIme'],
      postNaslov: json['postNaslov'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'korisnikId': korisnikId, 'postId': postId};
  }
}
