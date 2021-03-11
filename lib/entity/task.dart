import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String name;
  String description;
  int sumUsers;
  Timestamp expiredAt;
  Timestamp createdAt;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description ?? '',
      'sumUsers': sumUsers ?? 0,
      'expiredAt': expiredAt,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
