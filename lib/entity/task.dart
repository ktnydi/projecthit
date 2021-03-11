import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/task_field.dart';

class Task {
  String id;
  String name;
  String description;
  int sumUsers;
  Timestamp expiredAt;
  Timestamp createdAt;

  Task();

  Task.fromMap(Map<String, dynamic> map) {
    id = map[TaskField.id];
    name = map[TaskField.name];
    description = map[TaskField.description];
    sumUsers = map[TaskField.sumUsers];
    expiredAt = map[TaskField.expiredAt];
    createdAt = map[TaskField.createdAt];
  }

  Map<String, dynamic> toMap() {
    return {
      TaskField.name: name,
      TaskField.description: description ?? '',
      TaskField.sumUsers: sumUsers ?? 0,
      TaskField.expiredAt: expiredAt,
      TaskField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
