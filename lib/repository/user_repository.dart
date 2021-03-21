import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/extension/document_reference.dart';
import 'package:projecthit/entity/app_user.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  User get currentUser => _auth.currentUser;

  Stream<User> authListener() {
    return _auth.authStateChanges();
  }

  Stream<AppUser> fetchUser(String userId) {
    final userSnapshots = _store.collection('users').doc(userId).snapshots();
    return userSnapshots.map(
      (snapshot) {
        final data = snapshot.data();
        data['id'] = snapshot.id;
        return AppUser.fromMap(data);
      },
    );
  }

  Future<AppUser> fetchUserAsFuture(String userId) async {
    final userSnapshot =
        await _store.collection('users').doc(userId).getCacheThenServer();
    final data = userSnapshot.data();
    data['id'] = userSnapshot.id;
    return AppUser.fromMap(data);
  }

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

  Future<String> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user.uid;
  }

  Future<void> updateAppUser({AppUser appUser}) async {
    await _store.collection('users').doc(appUser.id).update(appUser.toMap());
  }

  Future<void> updateEmail({
    @required String email,
    @required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: _auth.currentUser.email,
      password: password,
    );

    try {
      await _auth.currentUser.reauthenticateWithCredential(credential);
      await _auth.currentUser.updateEmail(email);
      await _auth.currentUser.sendEmailVerification();
    } catch (e) {
      throw ('$e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
