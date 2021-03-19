import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/repository/project_user_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class InviteTaskMemberModel extends ChangeNotifier {
  final _projectUserRepository = ProjectUserRepository();
  final _userRepository = UserRepository();

  Stream<List<ProjectUser>> fetchProjectUser(Project project) {
    return _projectUserRepository.fetchProjectMember(project);
  }

  Future<AppUser> fetchUser(ProjectUser projectUser) async {
    return _userRepository.fetchUserAsFuture(projectUser.userId);
  }
}
