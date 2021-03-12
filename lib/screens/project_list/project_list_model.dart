import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/project_user_repository.dart';

class ProjectListModel extends ChangeNotifier {
  final _projectRepository = ProjectRepository();
  final _projectUserRepository = ProjectUserRepository();

  Stream<List<ProjectUser>> fetchProjectUsers() {
    return _projectUserRepository.fetchProjectUsers();
  }

  Stream<Project> fetchProject(ProjectUser projectUser) {
    return _projectRepository.fetchProject(projectUser);
  }
}
