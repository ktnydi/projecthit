import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/user_project_repository.dart';

class AddProjectModel extends ChangeNotifier {
  final _userProjectRepository = UserProjectRepository();
  final deadlineController = TextEditingController();
  ProjectRepository _projectRepository;
  bool isActiveDateTime = false;
  bool isLoading = false;
  Project project;
  StreamSubscription<Project> _projectSub;

  AddProjectModel({
    @required ProjectRepository projectRepository,
  }) : _projectRepository = projectRepository;

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

  Future<void> addProject({
    @required AppUser user,
    @required String name,
  }) async {
    if (user.sumUserProjects == 1) {
      throw ('You have already register project.');
    }

    final project = Project();
    project.name = name;
    await _projectRepository.addProject(user: user, project: project);
  }

  Future<void> fetchProject() async {
    final userProject = await _userProjectRepository.fetchUserProject();

    if (userProject == null) {
      return;
    }

    _projectSub = _projectRepository.fetchProjectFromId(userProject.id).listen(
      (project) {
        this.project = project;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    deadlineController.dispose();
    _projectSub?.cancel();
    super.dispose();
  }
}
