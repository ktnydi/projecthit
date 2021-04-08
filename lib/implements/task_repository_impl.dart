import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_field.dart';
import 'package:projecthit/entity/task.dart';
import 'package:projecthit/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final _store = FirebaseFirestore.instance;

  @override
  Stream<List<Task>> fetchTasks(Project project) {
    final taskSnapshot = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .orderBy('sortKey', descending: true)
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

  @override
  Future<void> doneTask(Project project, Task task) async {
    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc(task.id);
    await taskRef.update(task.toMap());
  }

  @override
  Future<void> addTask(Project project, Task task) async {
    final batch = _store.batch();

    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc();
    batch.set(taskRef, task.toMap());

    final projectRef = _store.collection('projects').doc(project.id);
    final newData = project.toMap()
      ..addAll(
        {
          ProjectField.sumTasks: FieldValue.increment(1),
        },
      );
    batch.update(projectRef, newData);

    await batch.commit();
  }

  @override
  Future<void> updateTask(Project project, Task task) async {
    final taskRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc(task.id);
    await taskRef.update(task.toMap());
  }

  @override
  Future<void> sortTasks(Project project, List<Task> taskList) async {
    WriteBatch batch = _store.batch();
    int batchCounter = 0;

    for (int i = 0; i < taskList.length; i++) {
      final task = taskList[i];
      task.sortKey = taskList.length - 1 - i;
      final taskRef = _store
          .collection('projects')
          .doc(project.id)
          .collection('projectTasks')
          .doc(task.id);
      batch.update(taskRef, task.toMap());
      batchCounter++;

      if (batchCounter == 500) {
        await batch.commit();

        batch = _store.batch();
        batchCounter = 0;
      }
    }
    await batch.commit();
  }

  @override
  Future<void> deleteTask(Project project, Task task) async {
    await _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .doc(task.id)
        .delete();
  }

  @override
  Future<void> deleteDoneTasks(Project project) async {
    final tasksSnapshot = await _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .where('isDone', isEqualTo: true)
        .get();

    const batchLimit = 500;
    WriteBatch batch = _store.batch();
    int batchCounter = 0;

    for (int i = 0; i < tasksSnapshot.docs.length; i++) {
      final doc = tasksSnapshot.docs[i];

      batch.delete(doc.reference);
      batchCounter++;

      if (batchCounter == batchLimit) {
        await batch.commit();
        batch = _store.batch();
        batchCounter = 0;
      }
    }

    await batch.commit();
  }
}
