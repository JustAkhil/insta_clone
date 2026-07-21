import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconButton? icon;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;

  const TextFieldInput({
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return TextField(
      cursorColor: blueColor,

      keyboardType: textInputType,
      controller: textEditingController,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        fillColor: mobileSearchColor,
        suffixIcon: icon,

        contentPadding: EdgeInsets.all(8),
      ),
    );
  }
}
