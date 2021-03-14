import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class TaskListModel extends ChangeNotifier {
  final Project project;
  final _taskRepository = TaskRepository();
  bool isLoading = false;

  TaskListModel({@required this.project});

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Stream<List<Task>> fetchTasks() {
    return _taskRepository.fetchTasks(project);
  }

  Future<void> doneTask(Task task) async {
    await _taskRepository.doneTask(project, task);
  }

  Future<void> deleteDoneTask() async {
    await _taskRepository.deleteDoneTasks(project);
  }
}
