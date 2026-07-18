import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String commentId;
  final String profilePic;
  final String text;
  final String uid;
  final DateTime datePublished;
  final String userName;

  CommentModel({
    required this.commentId,
    required this.profilePic,
    required this.text,
    required this.uid,
    required this.datePublished,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      "commentId": commentId,
      "profilePic": profilePic,
      "text": text,
      "uid": uid,
      "datePublished": datePublished,
      "userName": userName,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      commentId: data['commentId'] ?? '',
      profilePic: data['profilePic'] ?? '',
      text: data['text'] ?? '',
      uid: data['uid'] ?? '',
      datePublished: (data['datePublished'] as Timestamp).toDate(),
      userName: data['userName'] ?? '',
    );
  }
}
