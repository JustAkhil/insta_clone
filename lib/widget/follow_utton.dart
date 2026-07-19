import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Color backgroundColor;
  final Function()? function;
  final Color borderColor;
  final Color textColor;
  final String text;

  FollowButton({super.key,
    required this.backgroundColor,
    this.function,
    required this.borderColor,
    required this.textColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 55,
      padding: EdgeInsets.only(top: 8),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
