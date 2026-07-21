import 'dart:typed_data';

import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/constants/app_routes.dart';
import 'package:insta_clone/repository/auth_method.dart';
import '../../model/user_model.dart';
import '../../repository/storage_method.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../../widget/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Uint8List? _image;
  bool isPassHidden = true;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    userNameController.dispose();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var bioController = TextEditingController();
  var userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 32),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              "https://i.sstatic.net/l60Hf.png",
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextFieldInput(
                  textEditingController: userNameController,
                  hintText: "Username",
                  textInputType: TextInputType.name,
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  isPass: isPassHidden,
                  textEditingController: passwordController,
                  hintText: "Password",
                  textInputType: TextInputType.text,
                  icon: IconButton(onPressed: (){
                    setState(() {
                      isPassHidden = !isPassHidden;
                    });
                  }, icon:Icon(isPassHidden?Icons.visibility_off:Icons.visibility)),
                ),
                const SizedBox(height: 16),
                TextFieldInput(
                  textEditingController: bioController,
                  hintText: "Bio",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: signUp,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.loginScreen,
                        );
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() async {
    Uint8List image = await pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> signUp() async {
    if (userNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        bioController.text.isEmpty) {
      showSnackBar(context, "Please fill in all fields");
      return;
    }

    if (_image == null) {
      showSnackBar(context, "Please select an image");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethod().signUpUser(
      userName: userNameController.text.trim(),
      email: emailController.text.trim(),
      pass: passwordController.text.trim(),
      bio: bioController.text.trim(),
      file: _image!,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (res == 'success') {
        showSnackBar(context, "Account created successfully! Please login.");
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      } else {
        showSnackBar(context, res);
      }
    }
  }
}
