import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/app_routes.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/screens/ui/profile_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  PostModel postModel;

  PostCard({super.key, required this.postModel});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  late TapGestureRecognizer _usernameRecognizer;

  @override
  void initState() {
    super.initState();
    _usernameRecognizer = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _usernameRecognizer.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getCommentCount() {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postModel.postId)
        .collection("comments")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<UserProvider>().getUser;
    _usernameRecognizer.onTap = () => Navigator.pushNamed(
          context,
          AppRoutes.profile,
          arguments: widget.postModel.uid,
        );
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ).copyWith(right: 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.profile,
                    arguments: widget.postModel.uid,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.pink, Colors.purple],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: mobileBackgroundColor,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(widget.postModel.profImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.postModel.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (user?.uid == widget.postModel.uid)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: mobileSearchColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDialogItem(
                                    context: context,
                                    text: "Delete",
                                    textColor: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    onTap: () async {
                                      Navigator.pop(context);
                                      String res = await FireStoreMethods()
                                          .deletingPost(
                                        postId: widget.postModel.postId,
                                        postUrl: widget.postModel.postUrl,
                                      );
                                      if (context.mounted) {
                                        showSnackBar(context,
                                            res == "success" ? "Post Deleted" : res);
                                      }
                                    },
                                  ),
                                  const Divider(color: secondaryColor, height: 1),
                                  _buildDialogItem(
                                    context: context,
                                    text: "Cancel",
                                    onTap: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert, size: 24),
                  ),
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePosts(
                postId: widget.postModel.postId,
                uid: user!.uid,
                likes: widget.postModel.likes,
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Image.network(
                    widget.postModel.postUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      size: 100,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.postModel.likes.contains(user!.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () {
                    FireStoreMethods().likePosts(
                      postId: widget.postModel.postId,
                      uid: user.uid,
                      likes: widget.postModel.likes,
                    );
                  },
                  icon: widget.postModel.likes.contains(user.uid)
                      ? const Icon(Icons.favorite, color: Colors.red, size: 28)
                      : const Icon(Icons.favorite_border, size: 28),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.comment,
                  arguments: widget.postModel,
                ),
                icon: const Icon(Icons.chat_bubble_outline, size: 26),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined, size: 26),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, size: 28),
              ),
            ],
          ),
          // Description & Comments Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.postModel.likes.length} likes",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 4),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor, fontSize: 14),
                      children: [
                        TextSpan(
                          text: widget.postModel.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          recognizer: _usernameRecognizer,
                        ),
                        TextSpan(
                          text: "  ${widget.postModel.description}",
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.comment,
                    arguments: widget.postModel,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: StreamBuilder(
                      stream: getCommentCount(),
                      builder: (context, snapshot) {
                        int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                        return Text(
                          count > 0
                              ? "View all $count comments"
                              : "No comments yet",
                          style: const TextStyle(
                            fontSize: 14,
                            color: secondaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(widget.postModel.datePublished),
                  style: const TextStyle(
                    fontSize: 12,
                    color: secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogItem({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    Color textColor = primaryColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
