import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/repository/project_repository.dart';

class AddProjectModel extends ChangeNotifier {
  final _projectRepository = ProjectRepository();
  final deadlineController = TextEditingController();
  bool isActiveDateTime = false;
  bool isLoading = false;

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

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
