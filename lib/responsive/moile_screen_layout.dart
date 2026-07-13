import 'package:flutter/material.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel user=context.watch<UserProvider>().getUser;
    return Scaffold(
      body: Center(
        child: Text(
          user.username,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}