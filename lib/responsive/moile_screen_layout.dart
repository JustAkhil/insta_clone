import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/screens/ui/add_post.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/global_variable.dart';
import 'package:insta_clone/widget/loader.dart';
import 'package:provider/provider.dart';

import '../screens/ui/feed_screen.dart';
import '../screens/ui/profile_screen.dart';
import '../screens/ui/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.watch<UserProvider>().getUser;
    return user == null
        ? const Loader()
        : Scaffold(
            body: PageView(
              physics: BouncingScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChange,
              children: navPages,
            ),
            bottomNavigationBar: SizedBox(
              height: 100,
              child: CupertinoTabBar(
                onTap: navigationTapped,
                backgroundColor: mobileBackgroundColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                      size: 35,
                    ),
                    label: "",
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      color: _page == 1 ? primaryColor : secondaryColor,
                      size: 35,
                    ),
                    label: "",
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                      color: _page == 2 ? primaryColor : secondaryColor,
                      size: 35,
                    ),
                    label: "",
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.favorite,
                      color: _page == 3 ? primaryColor : secondaryColor,
                      size: 35,
                    ),
                    label: "",
                    backgroundColor: primaryColor,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                      color: _page == 4 ? primaryColor : secondaryColor,
                      size: 35,
                    ),
                    label: "",
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
          );
  }
}
