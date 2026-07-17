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
        return SimpleDialog(
          title: Text(
            "Create a post",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(source: ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(source: ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void postImage({
    required String uid,
    required String username,
    required String profImage,
  }) async {
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
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, res);
        clearImage();
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void  clearImage() {
    setState(() {
      _file = null;
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
            child: IconButton(
              onPressed: () => _selectImage(context),
              icon: Icon(Icons.upload, size: 50),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                "Post To",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              actions: [
                TextButton(
                  onPressed: () => postImage(
                    uid: userModel!.uid,
                    username: userModel.username,
                    profImage: userModel.photoUrl,
                  ),
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.pink,
                )
                    : Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(
                  color: mobileBackgroundColor,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userModel!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        autofocus: true,
                        cursorColor: Colors.blueAccent,
                        cursorWidth: 3,
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Write a caption...",
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
  }
}
