import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_project_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class AcceptInvitationModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  UserProjectRepository _userProjectRepository;
  bool isLoading = false;

  AcceptInvitationModel({UserProjectRepository userProjectRepository})
      : _userProjectRepository = userProjectRepository;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(AppUser appUser, Uri deepLink) async {
    final projectId = deepLink.queryParameters['id'];

    await _userProjectRepository.exitProject(appUser);
    await _userProjectRepository.joinProject(appUser, projectId);
  }

  Future<void> signInWithAnonymous() async {
    await _userRepository.signInAnonymous();
  }
}
