import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/repository/project_repository.dart';

class ProjectListModel extends ChangeNotifier {
  final _projectRepository = ProjectRepository();
  List<Project> projects = [];

  Future<void> fetchUserProjects() async {
    projects = await _projectRepository.fetchProjects();
    notifyListeners();
  }
}
