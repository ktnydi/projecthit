import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
