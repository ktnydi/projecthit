import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projecthit/entity/app_setting.dart';

class SettingRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<AppSetting> fetchAppSetting() async {
    final settingSnapshot = await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('settings')
        .doc(_auth.currentUser.uid)
        .get();
    return AppSetting.fromMap(settingSnapshot.data());
  }
}
