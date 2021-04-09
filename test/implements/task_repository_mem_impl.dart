import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class TaskRepositoryMemImpl implements TaskRepository {
  final List<Task> _data = [];

  int _currentId = 0;

  List<Task> get data => _data;
  int get currentId => _currentId;

  void incrementId() => _currentId++;

  void clear() {
    _data.clear();
    _currentId = 0;
  }

  @override
  Future<void> addTask(Project project, Task task) async {
    task.id = _currentId.toString();
    _data.add(task);
  }

  @override
  Future<void> deleteDoneTasks(Project project) async {
    // TODO: implement deleteDoneTasks
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(Project project, Task task) async {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<void> doneTask(Project project, Task task) async {
    // TODO: implement doneTask
    throw UnimplementedError();
  }

  @override
  Stream<List<Task>> fetchTasks(Project project) {
    // TODO: implement fetchTasks
    throw UnimplementedError();
  }

  @override
  Future<void> sortTasks(Project project, List<Task> taskList) async {
    // TODO: implement sortTasks
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(Project project, Task task) async {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
