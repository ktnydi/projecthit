import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:projecthit/entity/app_user_field.dart';

class AppUser {
  String id;
  String name;
  String icon;
  String about;
  int sumUserProjects;
  Timestamp createdAt;
  Timestamp updatedAt;

  AppUser({this.id});

  AppUser.fromMap(Map<String, dynamic> map) {
    id = map[AppUserField.id];
    name = map[AppUserField.name];
    icon = map[AppUserField.iconUrl];
    about = map[AppUserField.about];
    sumUserProjects = map[AppUserField.sumUserProjects];
    createdAt = map[AppUserField.createdAt] as Timestamp;
    updatedAt = map[AppUserField.updatedAt] as Timestamp;
  }

  // DB保存用
  Map<String, dynamic> toMap() {
    return {
      AppUserField.id: id,
      AppUserField.name: name ?? WordPair.random().asPascalCase,
      AppUserField.iconUrl: icon,
      AppUserField.about: about ?? '',
      AppUserField.sumUserProjects: sumUserProjects ?? 0,
      AppUserField.createdAt: createdAt ?? FieldValue.serverTimestamp(),
      AppUserField.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}
