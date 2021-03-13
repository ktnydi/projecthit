import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/repository/project_repository.dart';

class ProjectDetailModel extends ChangeNotifier {
  final _projectRepository = ProjectRepository();
  final deadlineController = TextEditingController();
  bool isLoading = false;
  bool isActiveDateTime = false;

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

  Future<void> updateProject({@required Project project}) async {
    await _projectRepository.updateProject(project: project);
  }

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
