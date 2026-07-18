import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/widget/post_card.dart';

import '../../utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreMethods().getAllPosts(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {
              PostModel postModel=PostModel.fromMap(snapShot.data!.docs[index].data());
              return PostCard(
                postModel: postModel,
              );
            },
          );
        },
      ),
    );
  }
}
