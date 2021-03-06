import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';

class AppUser {
  String id;
  String name;
  String icon;
  String about;
  DateTime createdAt;
  DateTime updatedAt;

  AppUser({this.id});

  AppUser.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    icon = map['icon'];
    about = map['about'];
    createdAt = (map['created_at'] as Timestamp).toDate();
    updatedAt = (map['updated_at'] as Timestamp).toDate();
  }

  // DB保存用
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name ?? WordPair.random().asPascalCase,
      'icon': icon,
      'about': about,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}
