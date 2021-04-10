import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/app_user_field.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_field.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/user_project.dart';
import 'package:projecthit/repository/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<Project> fetchProject(ProjectUser projectUser) {
    return projectUser.projectRef.snapshots().map(
      (snapshot) {
        final data = snapshot.data();

        if (data != null) {
          data[ProjectField.id] = snapshot.id;
          return Project.fromMap(data);
        }

        return null;
      },
    );
  }

  Stream<Project> fetchProjectFromId(String projectId) {
    return _store.collection('projects').doc(projectId).snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        if (data != null) {
          data[ProjectField.id] = snapshot.id;
          return Project.fromMap(data);
        }

        return null;
      },
    );
  }

  Future<String> addProject({
    @required AppUser user,
    @required Project project,
  }) async {
    final batch = _store.batch();

    final projectRef = _store.collection('projects').doc();
    project.adminUser = _auth.currentUser.uid;
    project.description = '';
    project.sumUsers = 1;
    batch.set(projectRef, project.toMap());

    final projectUserRef =
        projectRef.collection('projectUsers').doc(_auth.currentUser.uid);
    final projectUser = ProjectUser();
    projectUser.id = _auth.currentUser.uid;
    projectUser.userId = _auth.currentUser.uid;
    batch.set(projectUserRef, projectUser.toMap());

    final userProjectRef = _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .doc(projectRef.id);
    final userProject = UserProject();
    userProject.name = project.name;
    batch.set(userProjectRef, userProject.toMap());

    final userRef = _store.collection('users').doc(_auth.currentUser.uid);
    final newUser = user.toMap()
      ..addAll(
        {
          AppUserField.sumUserProjects: FieldValue.increment(1),
        },
      );
    batch.update(userRef, newUser);

    await batch.commit();
    return project.id;
  }

  Future<void> updateProject({@required Project project}) async {
    await _store.collection('projects').doc(project.id).update(project.toMap());
  }

  Future<void> deleteProject({@required Project project}) async {
    if (project.adminUser != _auth.currentUser.uid) return;

    const batchLimit = 500;
    WriteBatch batch = _store.batch();
    int batchCounter = 0;

    // プロジェクトを削除
    final projectRef = _store.collection('projects').doc(project.id);
    batchCounter++;
    batch.delete(projectRef);

    // プロジェクトメンバーを削除
    final projectUsersSnapshot =
        await projectRef.collection('projectUsers').get();
    for (int i = 0; i < projectUsersSnapshot.docs.length; i++) {
      final doc = projectUsersSnapshot.docs[i];

      batchCounter++;
      batch.delete(doc.reference);

      if (batchCounter == batchLimit) {
        await batch.commit();
        batch = _store.batch();
        batchCounter = 0;
      }
    }

    // プロジェクトタスクを削除
    final projectTasksSnapshot =
        await projectRef.collection('projectTasks').get();
    for (int i = 0; i < projectTasksSnapshot.docs.length; i++) {
      final doc = projectTasksSnapshot.docs[i];

      batchCounter++;
      batch.delete(doc.reference);

      if (batchCounter == batchLimit) {
        await batch.commit();
        batch = _store.batch();
        batchCounter = 0;
      }
    }

    await batch.commit();
  }
}
