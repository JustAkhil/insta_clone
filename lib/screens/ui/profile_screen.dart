import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/app_routes.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';

import 'package:insta_clone/widget/loader.dart';

import '../../utils/utils.dart';
import '../../widget/follow_utton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int postLength = 0;
  int followers = 0;
  int following = 0;
  UserModel? userModel;
  bool isFollowing = false;
  late Future<QuerySnapshot<Map<String, dynamic>>> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = FireStoreMethods().getUserPost(uid: widget.uid);
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      if (userSnap.data() != null) {
        userModel = UserModel.fromMap(userSnap.data()!);

        var postSnap = await FirebaseFirestore.instance
            .collection("posts")
            .where("uid", isEqualTo: widget.uid)
            .get();

        postLength = postSnap.docs.length;
        followers = userModel!.followers.length;
        following = userModel!.following.length;
        isFollowing = userModel!.followers.contains(
          FirebaseAuth.instance.currentUser!.uid,
        );
      }
      setState(() {});
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return userModel == null
        ? const Scaffold(body: Loader())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userModel!.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              actions: [
                if (FirebaseAuth.instance.currentUser!.uid == widget.uid)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => getData(),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Colors.orange, Colors.pink, Colors.purple],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: mobileBackgroundColor,
                                radius: 43,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(userModel!.photoUrl),
                                  radius: 40,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatColumn(postLength, "Posts"),
                                      buildStatColumn(followers, "Followers"),
                                      buildStatColumn(following, "Following"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel!.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                userModel!.bio,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? Expanded(
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        if (context.mounted) {
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            AppRoutes.loginScreen,
                                            (route) => false,
                                          );
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.grey),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Sign Out",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : isFollowing
                                    ? Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            FireStoreMethods().followUser(
                                              uid: FirebaseAuth.instance.currentUser!.uid,
                                              followId: userModel!.uid,

                                            );
                                            if (mounted) {
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            }
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.grey),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            "Unfollow",
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            FireStoreMethods().followUser(
                                              uid: FirebaseAuth.instance.currentUser!.uid,
                                              followId: userModel!.uid,
                                            );
                                            if (mounted) {
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: blueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          future: postFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Loader();
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text("No posts found"),
                                ),
                              );
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                DocumentSnapshot data = snapshot.data!.docs[index];
                                return Image(
                                  image: NetworkImage(data["postUrl"]),
                                  fit: BoxFit.cover,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
