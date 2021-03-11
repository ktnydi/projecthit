import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';

class TaskRepository {
  final _store = FirebaseFirestore.instance;

  Future<void> addTask(Project project, Task task) async {
    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc();
    await taskRef.set(task.toMap());
  }
}
