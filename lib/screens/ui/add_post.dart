import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/repository/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var _descriptionController = TextEditingController();
  Uint8List? _file;
  bool _isLoading = false;

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: mobileSearchColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Create a post",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(color: secondaryColor, height: 1),
                _buildDialogItem(
                  text: "Take a Photo",
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List? file =
                        await pickImage(source: ImageSource.camera);
                    if (file != null) {
                      setState(() {
                        _file = file;
                      });
                    }
                  },
                ),
                const Divider(color: secondaryColor, height: 1),
                _buildDialogItem(
                  text: "Choose from Gallery",
                  onTap: () async {
                    Navigator.pop(context);
                    Uint8List? file =
                        await pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      setState(() {
                        _file = file;
                      });
                    }
                  },
                ),
                const Divider(color: secondaryColor, height: 1),
                _buildDialogItem(
                  text: "Cancel",
                  textColor: Colors.red,
                  fontWeight: FontWeight.bold,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogItem({
    required String text,
    required VoidCallback onTap,
    Color textColor = primaryColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  void postImage({
    required String uid,
    required String username,
    required String profImage,
  }) async {
    if (_file == null) {
      showSnackBar(context, "Please select an image first");
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      showSnackBar(context, "Please enter a caption");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FireStoreMethods().uploadPost(
        description: _descriptionController.text,
        file: _file!,
        uid: uid,
        username: username,
        profImage: profImage,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Posted");
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? userModel = context.watch<UserProvider>().getUser;
    return _file == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload, size: 60, color: secondaryColor),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _selectImage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Select Photo",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                "New Post",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: false,
              leading: IconButton(
                onPressed: clearImage,
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    uid: userModel!.uid,
                    username: userModel.username,
                    profImage: userModel.photoUrl,
                  ),
                  child: const Text(
                    "Share",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                if (_isLoading)
                  const LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    color: blueColor,
                  ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Big Circular Image Preview
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.3,
                            backgroundImage: MemoryImage(_file!),
                            backgroundColor: mobileSearchColor,
                          ),
                          const SizedBox(height: 32),
                          // Description TextField
                          TextField(
                            controller: _descriptionController,
                            cursorColor: blueColor,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write a caption...",
                              hintStyle: TextStyle(color: secondaryColor),
                            ),
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
