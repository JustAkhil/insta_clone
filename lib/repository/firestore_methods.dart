import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/model/comment_model.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/repository/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload posts

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String res = "Some Error Occurred";
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage(
        uid,
        file,
        uid,
        true,
      );
      String postId = const Uuid().v1(); // generate new id using time
      PostModel postModel = PostModel(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );
      await _firestore.collection("posts").doc(postId).set(postModel.toMap());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePosts({
    required String postId,
    required String uid,
    required List likes,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    return _firestore.collection("posts").snapshots();
  }

  Future<void> postComment({
    required String postId,
    required String text,
    required String uid,
    required String userName,
    required String profilePic,
  }) async {
    try {
      if (text.isNotEmpty) {
        String commId = const Uuid().v1();
        CommentModel commentModel = CommentModel(
          commentId: commId,
          profilePic: profilePic,
          text: text,
          uid: uid,
          datePublished: DateTime.now(),
          userName: userName,
        );
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commId)
            .set(commentModel.toMap());
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPostComment({
    required String postId,
  }) {
    return _firestore
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("datePublished", descending: true)
        .snapshots();
  }
}
