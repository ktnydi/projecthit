import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/task.dart';

class TaskRepository {
  final _store = FirebaseFirestore.instance;

  Stream<List<Task>> fetchTasks(Project project) {
    final taskSnapshot = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .orderBy('createdAt', descending: true)
        .snapshots();
    final tasks = taskSnapshot.map(
      (snapshot) => snapshot.docs.map(
        (doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Task.fromMap(data);
        },
      ).toList(),
    );
    return tasks;
  }

  Future<void> doneTask(Project project, Task task) async {
    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc(task.id);
    await taskRef.update(task.toMap());
  }

  Future<void> addTask(Project project, Task task) async {
    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc();
    await taskRef.set(task.toMap());
  }
}
