import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTokenRepository {
  FirebaseFirestore _store = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> add(String token) async {
    await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('tokens')
        .doc(token)
        .set({});
  }
}
