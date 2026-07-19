import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../model/comment_model.dart';
import '../../widget/comment_card.dart';
import '../../widget/loader.dart';

class CommentScreen extends StatefulWidget {
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var _commentController = TextEditingController();
  late PostModel postModel;
  Stream<QuerySnapshot<Map<String, dynamic>>>? commentStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postModel = ModalRoute.of(context)!.settings.arguments as PostModel;
    commentStream ??=
        FireStoreMethods().getAllPostComment(postId: postModel.postId);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserProvider>().getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: commentStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No comments yet"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              commentModel:
                  CommentModel.fromMap(snapshot.data!.docs[index].data()),
            ),
            physics: BouncingScrollPhysics(),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    cursorColor: blueColor,
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: TextStyle(color: secondaryColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (_commentController.text.isNotEmpty) {
                    FireStoreMethods().postComment(
                      postId: postModel.postId,
                      text: _commentController.text,
                      uid: user.uid,
                      userName: user.username,
                      profilePic: user.photoUrl,
                    );
                    _commentController.clear();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
