import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/project_user_repository.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class TaskDetailModel extends ChangeNotifier {
  final _taskRepository = TaskRepository();
  final _projectUserRepository = ProjectUserRepository();
  final _userRepository = UserRepository();
  final focusNode = FocusNode();
  final deadlineController = TextEditingController();
  List<ProjectUser> projectUsers = [];
  StreamSubscription<List<ProjectUser>> projectUsersSub;
  List<String> projectTaskUserIds = [];
  bool isLoading = false;

  TaskDetailModel(Project project, Task task) {
    projectTaskUserIds = task.taskUserIds;

    projectUsersSub = _projectUserRepository
        .fetchProjectMember(project)
        .listen((projectUsers) {
      this.projectUsers = projectUsers;
      notifyListeners();
    });
  }

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  void selectUser(AppUser appUser) {
    projectTaskUserIds = [
      ...projectTaskUserIds,
      appUser.id,
    ];
    notifyListeners();
  }

  void deselectUser(AppUser appUser) {
    final newProjectTaskUserIds = [
      ...projectTaskUserIds,
    ];
    newProjectTaskUserIds.removeWhere(
      (projectTaskUserId) => projectTaskUserId == appUser.id,
    );
    projectTaskUserIds = newProjectTaskUserIds;
    notifyListeners();
  }

  Future<void> updateTask({
    @required Project project,
    @required Task task,
  }) async {
    task.taskUserIds = projectTaskUserIds;
    await _taskRepository.updateTask(project, task);
  }

  Future<void> deleteTask({
    @required Project project,
    @required Task task,
  }) async {
    await _taskRepository.deleteTask(project, task);
  }

  Stream<List<ProjectUser>> fetchProjectUser(Project project) {
    return _projectUserRepository.fetchProjectMember(project);
  }

  Future<AppUser> fetchUser(ProjectUser projectUser) async {
    return await _userRepository.fetchUserAsFuture(projectUser.userId);
  }

  @override
  void dispose() {
    projectUsersSub.cancel();
    deadlineController.dispose();
    super.dispose();
  }
}
