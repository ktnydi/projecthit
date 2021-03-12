import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class TaskDetailModel extends ChangeNotifier {
  final _taskRepository = TaskRepository();
  final focusNode = FocusNode();
  final deadlineController = TextEditingController();
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

  Future<void> updateTask({
    @required Project project,
    @required Task task,
  }) async {
    await _taskRepository.updateTask(project, task);
  }

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
