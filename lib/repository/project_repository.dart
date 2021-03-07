import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/entity/project.dart';

class ProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> addProject({@required Project project}) async {
    final projectRef = _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('projects')
        .doc();
    project.id = projectRef.id;
    project.adminRef = projectRef.parent.parent;
    project.body = '';
    project.sumMembers = 0;
    await projectRef.set(project.toMap());
    return project.id;
  }
}
