class Posts {
  final String userName;
  final String userImageUrl;
  final String postImageUrl;
  final String caption;
  int likeCounter;
  final String? id;

  Posts({
    this.id,
    required this.userName,
    required this.userImageUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likeCounter,
  });
}
