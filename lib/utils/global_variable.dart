import 'package:flutter/material.dart';

import '../screens/ui/add_post.dart';
import '../screens/ui/feed_screen.dart';

const webScreenSize = 600;

const navPages = [
  FeedScreen(),
  Text("SearchScreen"),
  AddPostScreen(),
  Text("LikeScreen"),
  Text("ProfileScreen"),
];