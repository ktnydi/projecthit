import 'package:flutter_test/flutter_test.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/screens/add_task/add_task_model.dart';

import 'implements/task_repository_mem_impl.dart';

void main() {
  final taskRepository = TaskRepositoryMemImpl();
  final model = AddTaskModel(
    project: Project()..sumTasks = 0,
    taskRepository: taskRepository,
  );

  group('add Task', () {
    test('valid', () async {
      taskRepository.clear();

      bool isSuccessful = true;

      try {
        await model.addTask(name: 'This is add task model test');
      } catch (e) {
        isSuccessful = false;
      }

      expect(isSuccessful, true);
      expect(taskRepository.data.length, 1);
      final newTask = taskRepository.data.first;
      expect(newTask.name, 'This is add task model test');
    });
  });
}
