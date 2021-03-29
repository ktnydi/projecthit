import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_setting.dart';
import 'package:projecthit/extension/document_reference.dart';
import 'package:projecthit/entity/app_user.dart';

class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _messaging = FirebaseMessaging.instance;

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

  Stream<List<AppUser>> fetchUsers(List<String> userIds) {
    // whereIn句で指定する配列は10件まで
    final usersSnapshots =
        _store.collection('users').where('id', whereIn: userIds).snapshots();

    return usersSnapshots.map(
      (snapshots) {
        return snapshots.docs.map(
          (doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return AppUser.fromMap(data);
          },
        ).toList();
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
      final appSetting = AppSetting();

      final userRef = _store.collection('users').doc(userCredential.user.uid);
      final settingRef =
          userRef.collection('settings').doc(userCredential.user.uid);

      final batch = _store.batch();

      batch.set(userRef, appUser.toMap());
      batch.set(settingRef, appSetting.toMap());

      await batch.commit();

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
    final token = await _messaging.getToken();
    await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('tokens')
        .doc(token)
        .delete();
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> uploadProfileImage({File imageFile}) async {
    final profileImageFileRef = _storage
        .ref()
        .child('users')
        .child(_auth.currentUser.uid)
        .child('images')
        .child('profile.jpg');

    final uploadTask = await profileImageFileRef.putFile(
      imageFile,
      SettableMetadata(
        contentType: 'image/jpg',
      ),
    );

    return await uploadTask.ref.getDownloadURL();
  }
}
