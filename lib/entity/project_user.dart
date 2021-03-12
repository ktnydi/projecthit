import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project_user_field.dart';

class ProjectUser {
  String id;
  String userId;
  DocumentReference projectRef;
  Timestamp createdAt;

  ProjectUser();

  ProjectUser.fromMap(Map<String, dynamic> map) {
    id = map[ProjectUserField.id];
    userId = map[ProjectUserField.userId];
    projectRef = map[ProjectUserField.projectRef];
    createdAt = map[ProjectUserField.createdAt];
  }

  Map<String, dynamic> toMap() {
    return {
      ProjectUserField.userId: userId,
      ProjectUserField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
