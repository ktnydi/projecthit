import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  User get currentUser => _auth.currentUser;

  Future<String> signInAnonymous() async {
    final userCredential = await _auth.signInAnonymously();

    if (userCredential.user == null) return null;

    try {
      final appUser = AppUser(id: userCredential.user.uid);

      await _store
          .collection('users')
          .doc(userCredential.user.uid)
          .set(appUser.toMap());

      return appUser.id;
    } catch (e) {
      await userCredential.user.delete();
      throw ('$e');
    }
  }

  Future<void> linkWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await _auth.currentUser.linkWithCredential(credential);

      await _auth.currentUser.sendEmailVerification();
    } catch (e) {
      throw ('$e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
