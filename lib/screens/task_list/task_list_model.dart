import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class TaskListModel extends ChangeNotifier {
  final Project project;
  final _userRepository = UserRepository();
  TaskRepository _taskRepository;
  bool isLoading = false;

  TaskListModel({
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

  Stream<List<Task>> fetchTasks() {
    return _taskRepository.fetchTasks(project);
  }

  Future<void> doneTask(Task task) async {
    await _taskRepository.doneTask(project, task);
  }

  Stream<List<AppUser>> fetchTaskUsers(List<String> userIds) {
    return _userRepository.fetchUsers(userIds);
  }

  Future<void> sortTasks(Project project, List<Task> taskList) async {
    await _taskRepository.sortTasks(project, taskList);
  }
}
