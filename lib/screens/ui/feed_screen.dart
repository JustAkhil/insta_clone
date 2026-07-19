import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_clone/model/post_model.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/widget/loader.dart';
import 'package:insta_clone/widget/post_card.dart';

import '../../utils/colors.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, size: 26),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.messenger_outline, size: 26),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FireStoreMethods().getAllPosts(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (!snapShot.hasData || snapShot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No posts yet"),
            );
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapShot.data!.docs.length,
            itemBuilder: (context, index) {
              PostModel postModel = PostModel.fromMap(
                snapShot.data!.docs[index].data(),
              );
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
