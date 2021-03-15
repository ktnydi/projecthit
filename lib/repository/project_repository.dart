import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_field.dart';
import 'package:projecthit/entity/project_user.dart';

class ProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<Project> fetchProject(ProjectUser projectUser) {
    return projectUser.projectRef.snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        data[ProjectField.id] = snapshot.id;
        return Project.fromMap(data);
      },
    );
  }

  Future<String> addProject({@required Project project}) async {
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
