import 'package:flutter/cupertino.dart';
import 'package:insta_clone/screens/on_boarding/sign_up_screen.dart';
import 'package:insta_clone/screens/ui/home_page.dart';

import '../responsive/moile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../screens/on_boarding/login_page.dart';
class AppRoutes {
  static const String loginScreen="/login";
  static const String signUp="/sign_up";
  static const String homePage="/home";

  static Map<String,WidgetBuilder>appRoutes()=>{
    loginScreen:(context)=>LoginScreen(),
    signUp:(context)=>SignUpScreen(),
    homePage: (context) => const ResponsiveLayoutScreen(
      webScreenLayout: WebScreenLayout(),
      mobileScreenLayout: MobileScreenLayout(),
    ),
  };
}