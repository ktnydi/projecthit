import 'package:projecthit/entity/user_project_field.dart';

class UserProject {
  String id;
  String name;

  UserProject();

  UserProject.fromMap(Map<String, dynamic> map) {
    id = map[UserProjectField.id];
    name = map[UserProjectField.name];
  }

  Map<String, dynamic> toMap() {
    return {
      UserProjectField.name: name,
    };
  }
}
