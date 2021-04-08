import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class AddTaskModel extends ChangeNotifier {
  final Project project;
  TaskRepository _taskRepository;
  bool isLoading = false;

  AddTaskModel({
    @required this.project,
    @required TaskRepository taskRepository,
  }) {
    _taskRepository = taskRepository;
  }

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
    task.sortKey = project.sumTasks;
    await _taskRepository.addTask(project, task);
  }
}
