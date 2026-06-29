import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    String uid,
    bool isPost,
  ) async{
    Reference ref =
    _storage.ref("profile-pic").child(childName).child("$uid.jpg");
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot snap=await uploadTask;
    String downloadUrl=await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
