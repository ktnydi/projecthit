import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/project_user_repository.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class ProjectDetailModel extends ChangeNotifier {
  final _projectUserRepository = ProjectUserRepository();
  final _userRepository = UserRepository();
  final deadlineController = TextEditingController();
  ProjectRepository _projectRepository;
  TaskRepository _taskRepository;
  List<ProjectUser> projectUsers = [];
  StreamSubscription<List<ProjectUser>> projectUsersStream;
  bool isLoading = false;
  bool isActiveDateTime = false;

  ProjectDetailModel({
    @required ProjectRepository projectRepository,
    @required TaskRepository taskRepository,
  })  : _projectRepository = projectRepository,
        _taskRepository = taskRepository;

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

  void fetchProjectUsers(Project project) {
    projectUsersStream =
        _projectUserRepository.fetchProjectMember(project).listen(
      (projectUsers) {
        this.projectUsers = projectUsers;
        notifyListeners();
      },
    );
  }

  Future<AppUser> fetchUser(ProjectUser projectUser) async {
    return await _userRepository.fetchUserAsFuture(projectUser.userId);
  }

  Future<void> updateProject({@required Project project}) async {
    await _projectRepository.updateProject(project: project);
  }

  Future<void> deleteProject({@required Project project}) async {
    await _projectRepository.deleteProject(project: project);
  }

  Future<void> deleteDoneTask(Project project) async {
    await _taskRepository.deleteDoneTasks(project);
  }

  @override
  void dispose() {
    deadlineController.dispose();
    projectUsersStream.cancel();
    super.dispose();
  }
}
