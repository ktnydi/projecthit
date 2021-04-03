import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project_field.dart';

class Project {
  String id;
  String name;
  String description;
  int sumUsers;
  int sumTasks;
  String adminUser;
  Timestamp createdAt;

  Project();

  Project.fromMap(Map<String, dynamic> map) {
    id = map[ProjectField.id];
    name = map[ProjectField.name];
    description = map[ProjectField.description];
    sumUsers = map[ProjectField.sumUsers] as int;
    sumTasks = map[ProjectField.sumTasks] as int;
    adminUser = map[ProjectField.adminUser];
    createdAt = map[ProjectField.createdAt] as Timestamp;
  }

  // DB保存用
  Map<String, dynamic> toMap() {
    return {
      ProjectField.name: name,
      ProjectField.description: description,
      ProjectField.sumUsers: sumUsers,
      ProjectField.sumTasks: sumTasks ?? 0,
      ProjectField.adminUser: adminUser,
      ProjectField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
