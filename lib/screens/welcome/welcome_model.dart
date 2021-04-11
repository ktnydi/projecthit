import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/user_project.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/user_project_repository.dart';

class WelcomeModel extends ChangeNotifier {
  UserProjectRepository _userProjectRepository;
  ProjectRepository _projectRepository;
  StreamSubscription<Project> _projectSub;
  UserProject userProject;
  Project project;

  WelcomeModel({
    @required UserProjectRepository userProjectRepository,
    @required ProjectRepository projectRepository,
  })  : _userProjectRepository = userProjectRepository,
        _projectRepository = projectRepository;

  Future<void> fetchProject() async {
    userProject = await _userProjectRepository.fetchUserProject();

    _projectSub = _projectRepository.fetchProjectFromId(userProject.id).listen(
      (project) {
        this.project = project;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _projectSub?.cancel();
    super.dispose();
  }
}
