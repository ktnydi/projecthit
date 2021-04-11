import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/user_project.dart';
import 'package:projecthit/repository/user_project_repository.dart';

class UserProjectRepositoryMemImpl implements UserProjectRepository {
  @override
  Future<void> exitProject(AppUser appUser) {
    // TODO: implement exitProject
    throw UnimplementedError();
  }

  @override
  Future<UserProject> fetchUserProject() {
    // TODO: implement fetchUserProject
    throw UnimplementedError();
  }

  @override
  Future<void> joinProject(AppUser appUser, String newProjectId) {
    // TODO: implement joinProject
    throw UnimplementedError();
  }
}
