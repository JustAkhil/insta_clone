class PostModel {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final List likes;


  PostModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "uid": uid,
      "username": username,
      "postId": postId,
      "datePublished": datePublished,
      "postUrl": postUrl,
      "profImage": profImage,
      "likes": likes,
    };
  }
  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      description: data['description'] ?? '',
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      postId: data['postId'] ?? '',
      datePublished: data['datePublished'] ?? '',
      postUrl: data['postUrl'] ?? [],
      profImage: data['profImage'] ?? [],
      likes: data['likes'] ?? 0,
    );
  }
}