import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone/model/user_model.dart';
import 'package:insta_clone/repository/storage_method.dart';
class AuthMethod {
  static const String USER_COLLECTION = "users";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetail() async {
    User? currUser = _auth.currentUser;
    if (currUser == null) {
      throw Exception("No user logged in");
    }
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection(USER_COLLECTION).doc(currUser.uid).get();
    if (!snap.exists || snap.data() == null) {
      throw Exception("User data not found in Firestore");
    }
    return UserModel.fromMap(snap.data()!);
  }
  Future<String> signUpUser({
    required String userName,
    required String email,
    required String pass,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "All fields are required";
    try {
      if (email.isNotEmpty &&
          pass.isNotEmpty &&
          userName.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        String photoUrl = await StorageMethod().uploadImageToStorage(
          cred.user!.uid,
          file,
          cred.user!.uid,
          false,
        );
        if (cred.user!.uid != null) {
          UserModel userModel = UserModel(
            username: userName,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: [],
          );
          await _firestore
              .collection("users")
              .doc(cred.user!.uid)
              .set(userModel.toMap());
        }
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = "Password is too weak";
      } else if (e.code == 'email-already-in-use') {
        res = "Email already exists";
      } else if (e.code == 'invalid-email') {
        res = "Invalid Email";
      } else {
        res = "Signup failed";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String pass,
  }) async {
    String res = "All fields are required";
    try {
      if (email.isNotEmpty && pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        res = "Invalid email or password";
      } else if (e.code == 'invalid-email') {
        res = "Invalid email format";
      } else if (e.code == 'user-disabled') {
        res = "Account disabled";
      } else if (e.code == 'too-many-requests') {
        res = "Too many attempts. Try later";
      } else {
        res = "Login failed. Try again";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
