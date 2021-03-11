import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class TaskListModel extends ChangeNotifier {
  final Project project;
  final _taskRepository = TaskRepository();

  TaskListModel({@required this.project});

  Stream<List<Task>> fetchTasks() {
    return _taskRepository.fetchTasks(project);
  }
}
