import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/user_project.dart';

abstract class UserProjectRepository {
  Future<void> exitProject(AppUser appUser);
  Future<void> joinProject(AppUser appUser, String newProjectId);
  Future<UserProject> fetchUserProject();
}
