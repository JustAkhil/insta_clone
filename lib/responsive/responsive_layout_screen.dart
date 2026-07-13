import 'package:flutter/cupertino.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../utils/dimension.dart';
class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;

  const ResponsiveLayoutScreen({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData(){
    UserProvider _userProvider=context.read();
    _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web screen
          return widget.webScreenLayout;
        } else {
          //mobile screen
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}