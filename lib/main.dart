import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:insta_clone/constants/app_routes.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/repository/auth_method.dart';
import 'package:insta_clone/responsive/moile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin(),
      routes: AppRoutes.appRoutes(),
    );
  }

  String isLogin() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AppRoutes.homePage;
    } else {
      return AppRoutes.loginScreen;
    }
  }
}
