import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> fetchTasks(Project project);
  Future<void> doneTask(Project project, Task task);
  Future<void> addTask(Project project, Task task);
  Future<void> updateTask(Project project, Task task);
  Future<void> sortTasks(Project project, List<Task> taskList);
  Future<void> deleteTask(Project project, Task task);
  Future<void> deleteDoneTasks(Project project);
}
