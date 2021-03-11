import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class AddTaskModel extends ChangeNotifier {
  final _taskRepository = TaskRepository();
  final Project project;
  bool isLoading = false;

  AddTaskModel({@required this.project});

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    @required String name,
  }) async {
    final task = Task();
    task.name = name;
    await _taskRepository.addTask(project, task);
  }
}
