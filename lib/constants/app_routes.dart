import 'package:flutter/cupertino.dart';
import 'package:insta_clone/screens/on_boarding/sign_up_screen.dart';
import 'package:insta_clone/screens/ui/add_post.dart';
import '../responsive/moile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../screens/on_boarding/login_page.dart';
import '../screens/ui/comment_screen.dart';
import '../screens/ui/feed_screen.dart';
import '../screens/ui/profile_screen.dart';

class AppRoutes {
  static const String loginScreen = "/login";
  static const String signUp = "/sign_up";
  static const String homePage = "/home";
  static const String addPost = "/add_post";
  static const String feed = "/feed";
  static const String comment = "/comment";
  static const String profile = "/profile";

  static Map<String, WidgetBuilder> appRoutes() => {
        loginScreen: (context) => LoginScreen(),
        signUp: (context) => SignUpScreen(),
        homePage: (context) => const ResponsiveLayoutScreen(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
        addPost: (context) => AddPostScreen(),
        feed: (context) => FeedScreen(),
        comment: (context) => CommentScreen(),
        profile: (context) => ProfileScreen(
              uid: ModalRoute.of(context)!.settings.arguments as String,
            ),
      };
}