import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'colors.dart';

pickImage({required ImageSource source}) async {
  final ImagePicker imgPicker = ImagePicker();
  XFile? file = await imgPicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print("No image selected");
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: const TextStyle(
          color: primaryColor,
          fontSize: 14,
        ),
      ),
      backgroundColor: mobileSearchColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(
        left: 50,
        right: 50,
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
