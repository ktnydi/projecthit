import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/project_user_field.dart';

class ProjectUserRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<ProjectUser>> fetchProjectUsers() {
    final projectUserSnapshots = _store
        .collectionGroup('projectUsers')
        .where('userId', isEqualTo: _auth.currentUser.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
    return projectUserSnapshots.map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final data = doc.data();
            data[ProjectUserField.id] = doc.id;
            data[ProjectUserField.projectRef] = doc.reference.parent.parent;
            return ProjectUser.fromMap(data);
          },
        ).toList();
      },
    );
  }
}