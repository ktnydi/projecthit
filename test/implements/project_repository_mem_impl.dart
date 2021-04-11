import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/repository/project_repository.dart';

class ProjectRepositoryMemImpl implements ProjectRepository {
  Project project;

  void clear() {
    project = null;
  }

  @override
  Future<String> addProject({AppUser user, Project project}) {
    this.project = project;
    return Future.value(project.id);
  }

  @override
  Future<void> deleteProject({Project project}) {
    // TODO: implement deleteProject
    throw UnimplementedError();
  }

  @override
  Stream<Project> fetchProject(ProjectUser projectUser) {
    // TODO: implement fetchProject
    throw UnimplementedError();
  }

  @override
  Stream<Project> fetchProjectFromId(String projectId) {
    // TODO: implement fetchProjectFromId
    throw UnimplementedError();
  }

  @override
  Future<void> updateProject({Project project}) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }
}
