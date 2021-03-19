import 'package:flutter/material.dart';
import 'package:projecthit/repository/project_user_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class AcceptInvitationModel extends ChangeNotifier {
  final _projectUserRepository = ProjectUserRepository();
  final _userRepository = UserRepository();
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(Uri deepLink) async {
    final projectId = deepLink.queryParameters['id'];

    await _projectUserRepository.addProjectUser(projectId);
  }

  Future<void> signInWithAnonymous() async {
    await _userRepository.signInAnonymous();
  }
}
