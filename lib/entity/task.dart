import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/task_field.dart';

class Task {
  String id;
  String name;
  String description;
  bool isDone;
  List<String> taskUserIds;
  int sortKey;
  Timestamp expiredAt;
  Timestamp createdAt;

  bool get isExpired {
    return expiredAt != null &&
        expiredAt.millisecondsSinceEpoch <=
            Timestamp.now().millisecondsSinceEpoch;
  }

  Task();

  Task.fromMap(Map<String, dynamic> map) {
    id = map[TaskField.id];
    name = map[TaskField.name];
    description = map[TaskField.description];
    isDone = map[TaskField.isDone];
    taskUserIds = (map[TaskField.taskUserIds] as List)
        .map((userId) => userId as String)
        .toList();
    sortKey = map[TaskField.sortKey];
    expiredAt = map[TaskField.expiredAt];
    createdAt = map[TaskField.createdAt];
  }

  Map<String, dynamic> toMap() {
    return {
      TaskField.name: name,
      TaskField.description: description ?? '',
      TaskField.isDone: isDone ?? false,
      TaskField.taskUserIds: taskUserIds ?? [],
      TaskField.sortKey: sortKey,
      TaskField.expiredAt: expiredAt,
      TaskField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
