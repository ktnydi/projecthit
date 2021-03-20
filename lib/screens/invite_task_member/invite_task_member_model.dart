import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/project_user_repository.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class InviteTaskMemberModel extends ChangeNotifier {
  final _projectUserRepository = ProjectUserRepository();
  final _userRepository = UserRepository();
  final _taskRepository = TaskRepository();
  List<AppUser> projectTaskUsers = [];
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void selectUser(AppUser appUser) {
    projectTaskUsers = [
      ...projectTaskUsers,
      appUser,
    ];
    notifyListeners();
  }

  void deselectUser(AppUser appUser) {
    final newProjectTaskUsers = [
      ...projectTaskUsers,
    ];
    newProjectTaskUsers.removeWhere(
      (projectTaskUser) => projectTaskUser.id == appUser.id,
    );
    projectTaskUsers = newProjectTaskUsers;
    notifyListeners();
  }

  Stream<List<ProjectUser>> fetchProjectUser(Project project) {
    return _projectUserRepository.fetchProjectMember(project);
  }

  Future<AppUser> fetchUser(ProjectUser projectUser) async {
    return await _userRepository.fetchUserAsFuture(projectUser.userId);
  }

  Future<void> addProjectTaskUsers(
    Project project,
    Task task,
  ) async {
    task.taskUserIds = projectTaskUsers.map((user) => user.id).toList();
    await _taskRepository.updateTask(project, task);
  }
}
