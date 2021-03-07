import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project_field.dart';

class Project {
  String id;
  String title;
  String body;
  int sumMembers;
  DocumentReference adminRef;
  Timestamp createdAt;
  Timestamp updatedAt;

  Project();

  Project.fromMap(Map<String, dynamic> map) {
    id = map[ProjectField.id];
    title = map[ProjectField.title];
    body = map[ProjectField.body];
    sumMembers = map[ProjectField.sumMembers] as int;
    adminRef = map[ProjectField.adminRef];
    createdAt = map[ProjectField.createdAt] as Timestamp;
    updatedAt = map[ProjectField.updatedAt] as Timestamp;
  }

  // DB保存用
  Map<String, dynamic> toMap() {
    return {
      ProjectField.id: id,
      ProjectField.title: title,
      ProjectField.body: body,
      ProjectField.sumMembers: sumMembers,
      ProjectField.adminRef: adminRef,
      ProjectField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      ProjectField.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}
