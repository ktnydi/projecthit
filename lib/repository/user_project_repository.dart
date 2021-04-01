import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/entity/app_user_field.dart';
import 'package:projecthit/entity/project.dart';
import 'package:projecthit/entity/project_field.dart';
import 'package:projecthit/entity/project_user.dart';
import 'package:projecthit/entity/task_field.dart';
import 'package:projecthit/entity/user_project.dart';
import 'package:projecthit/entity/user_project_field.dart';

class UserProjectRepository {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> exitProject(AppUser appUser) async {
    WriteBatch batch = _store.batch();
    int batchCounter = 0;

    // 現在のプロジェクトを取得
    final userProjectSnapshot = await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .get();
    final projectId = userProjectSnapshot.docs.first.id;

    final projectSnapshot =
        await _store.collection('projects').doc(projectId).get();
    final projectData = projectSnapshot.data();
    projectData[ProjectField.id] = projectSnapshot.id;
    final project = Project.fromMap(projectData);

    // 現在参加中のプロジェクトの削除する
    final userProjectRef = _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .doc(project.id);

    batch.delete(userProjectRef);
    batchCounter++;

    // 参加中のプロジェクト数の更新する
    final userRef = _store.collection('users').doc(_auth.currentUser.uid);
    final newAppUserMap = appUser.toMap()
      ..addAll({
        AppUserField.sumUserProjects: FieldValue.increment(-1),
      });
    batch.update(userRef, newAppUserMap);
    batchCounter++;

    // 参加中のプロジェクトから退化する
    final projectUserRef = _store
        .collection('projects')
        .doc(project.id)
        .collection('projectUsers')
        .doc(_auth.currentUser.uid);

    batch.delete(projectUserRef);
    batchCounter++;

    // 自分に割り振られたタスクの更新する
    final projectTasksSnapshot = await _store
        .collection('projects')
        .doc(project.id)
        .collection('projectTasks')
        .where('taskUserIds', arrayContains: _auth.currentUser.uid)
        .get();

    for (int i = 0; i < projectTasksSnapshot.docs.length; i++) {
      final projectTaskDoc = projectTasksSnapshot.docs[i];

      final projectTaskData = projectTaskDoc.data();
      projectTaskData[TaskField.taskUserIds] = [];
      batch.update(projectTaskDoc.reference, projectTaskData);
      batchCounter++;

      if (batchCounter == 500) {
        await batch.commit();
        batch = _store.batch();
        batchCounter = 0;
      }
    }

    final projectRef = _store.collection('projects').doc(project.id);
    if (project.sumUsers == 1) {
      // 自分だけのプロジェクトを削除する
      batch.delete(projectRef);
      batchCounter++;
    } else {
      // 自分以外も存在するなら参加人数を減らす
      final updateField = {ProjectField.sumUsers: FieldValue.increment(-1)};

      batch.update(
        projectRef,
        project.toMap()..addAll(updateField),
      );
      batchCounter++;
    }

    await batch.commit();
  }

  Future<void> joinProject(AppUser appUser, String newProjectId) async {
    WriteBatch batch = _store.batch();

    // 新しいプロジェクトに参加する
    final userProjectRef = _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .doc(newProjectId);
    final userProject = UserProject();
    userProject.name = 'no name';
    batch.set(userProjectRef, userProject.toMap());

    // 参加中のプロジェクト数を更新する
    final userRef = _store.collection('users').doc(_auth.currentUser.uid);
    final newAppUserMap = appUser.toMap()
      ..addAll({
        AppUserField.sumUserProjects: FieldValue.increment(1),
      });
    batch.update(userRef, newAppUserMap);

    // 新しいプロジェクトに登録する
    final projectUserRef = _store
        .collection('projects')
        .doc(newProjectId)
        .collection('projectUsers')
        .doc(_auth.currentUser.uid);
    final projectUser = ProjectUser();
    projectUser.userId = _auth.currentUser.uid;
    batch.set(projectUserRef, projectUser.toMap());

    await batch.commit();

    // 新しいプロジェクトに登録したので、ここで参加人数を更新
    final newProjectSnapshot =
        await _store.collection('projects').doc(newProjectId).get();
    final newProjectData = newProjectSnapshot.data();
    newProjectData[ProjectField.sumUsers] = FieldValue.increment(1);
    await newProjectSnapshot.reference.update(newProjectData);
  }

  Future<UserProject> fetchUserProject() async {
    // userProjectIdは不明なのでリストで取得する。
    final userProjectsSnapshot = await _store
        .collection('users')
        .doc(_auth.currentUser.uid)
        .collection('userProjects')
        .get();

    if (userProjectsSnapshot.docs.isEmpty) {
      return null;
    }

    // 登録しているプロジェクトは1つだけなのでList.firstで取得する。
    final doc = userProjectsSnapshot.docs.first;
    final data = doc.data();
    data[UserProjectField.id] = doc.id;
    return UserProject.fromMap(data);
  }
}
