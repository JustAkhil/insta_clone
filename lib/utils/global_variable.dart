import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/ui/profile_screen.dart';

import '../screens/ui/add_post.dart';
import '../screens/ui/feed_screen.dart';
import '../screens/ui/search_screen.dart';

const webScreenSize = 600;

const navPages = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("LikeScreen")),
];
