class KatalogPost {
  final int katalogPostId;
  final int postId;
  final String postNaslov;
  final String? postSlika;
  final bool premium;

  KatalogPost({
    required this.katalogPostId,
    required this.postId,
    required this.postNaslov,
    this.postSlika,
    required this.premium,
  });

  factory KatalogPost.fromJson(Map<String, dynamic> json) {
    return KatalogPost(
      katalogPostId: json['katalogPostId'],
      postId: json['postId'],
      postNaslov: json['postNaslov'],
      postSlika: json['postSlika'],
      premium: json['premium'],
    );
  }
}
