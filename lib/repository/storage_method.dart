import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
    String uid,
    bool isPost,
  ) async{
    Reference ref;
    if(isPost){
      String id=const Uuid().v1();
      ref =
      _storage.ref("posts").child(childName).child("$id.jpg");
    }else{
      ref =
      _storage.ref("profile-pic").child(childName).child("$uid.jpg");
    }
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot snap=await uploadTask;
    String downloadUrl=await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
