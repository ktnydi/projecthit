import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projecthit/entity/user_project.dart';
import 'package:projecthit/entity/user_project_field.dart';

class UserProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<UserProject> fetchUserProject() async {
    // userProjectIdは不明なのでリストで取得する。
    final userProjectsSnapshot = await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .get();

    if (userProjectsSnapshot.docs.isEmpty) {
      return null;
    }

    // 登録しているプロジェクトは1つだけなのでList.firstで取得する。
    final doc = userProjectsSnapshot.docs.first;
    final data = doc.data();
    data[UserProjectField.id] = doc.id;
    return UserProject.fromMap(data);
  }
}
