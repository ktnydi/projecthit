import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';

abstract class ProjectRepository {
  Stream<Project> fetchProject(ProjectUser projectUser);
  Stream<Project> fetchProjectFromId(String projectId);
  Future<String> addProject(
      {@required AppUser user, @required Project project});
  Future<void> updateProject({@required Project project});
  Future<void> deleteProject({@required Project project});
}
