import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_user.dart';

class ProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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
}
