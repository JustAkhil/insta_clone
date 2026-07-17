import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPosts() {
    return _firestore.collection("posts").snapshots();
  }
}
