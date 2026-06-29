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
  bool isPassHidden = false;
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: 64,
              ),
              SizedBox(height: 24),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
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
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              TextFieldInput(
                textEditingController: userNameController,
                hintText: "Enter your username",
                textInputType: TextInputType.name,
              ),
              SizedBox(height: 24),
              TextFieldInput(
                textEditingController: emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              TextFieldInput(
                isPass: isPassHidden,
                textEditingController: passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 24),
              TextFieldInput(
                textEditingController: bioController,
                hintText: "Enter your bio",
                textInputType: TextInputType.text,
              ),
              SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: blueColor,
                ),
                child: TextButton(
                  onPressed: signUp,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 2),
              Flexible(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Log in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
    setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      showSnackBar(context, "Please select an image");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    String res = await AuthMethod().signUpUser(
      userName: userNameController.text.trim(),
      email: emailController.text.trim(),
      pass: passwordController.text.trim(),
      bio: bioController.text.trim(),
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      showSnackBar(context, res);
    }else{
      showSnackBar(context, res);
    }
  }
}
