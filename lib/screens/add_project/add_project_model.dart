import 'package:flutter/material.dart';
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

  Future<void> addProject({@required String title}) async {
    final project = Project();
    project.title = title;
    await _projectRepository.addProject(project: project);
  }

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
