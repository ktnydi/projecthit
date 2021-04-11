import 'package:flutter_test/flutter_test.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/screens/add_project/add_project_model.dart';

import 'implements/project_repository_mem_impl.dart';
import 'implements/user_project_repository_mem_impl.dart';

void main() {
  final userProjectRepository = UserProjectRepositoryMemImpl();
  final projectRepository = ProjectRepositoryMemImpl();
  final model = AddProjectModel(
    userProjectRepository: userProjectRepository,
    projectRepository: projectRepository,
  );

  group('add project', () {
    test('when user have not project', () async {
      projectRepository.clear();

      final user = AppUser(id: '1234')..sumUserProjects = 0;

      bool isSuccess = true;

      try {
        await model.addProject(user: user, name: 'New project');
      } catch (e) {
        isSuccess = false;
      }

      expect(isSuccess, true);
      expect(projectRepository.project.name, 'New project');
    });

    test('when user have already created project', () async {
      projectRepository.clear();

      final user = AppUser(id: '1234')..sumUserProjects = 1;

      bool isSuccess = true;

      try {
        await model.addProject(user: user, name: 'New project');
      } catch (e) {
        isSuccess = false;
      }

      expect(isSuccess, false);
      expect(projectRepository.project, null);
    });
  });
}
