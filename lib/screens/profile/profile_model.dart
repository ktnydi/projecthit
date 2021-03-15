import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_user.dart';
import 'package:projecthit/repository/user_repository.dart';

class ProfileModel extends ChangeNotifier {
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

  Future<void> updateAppUser(AppUser appUser) async {
    await _userRepository.updateAppUser(appUser: appUser);
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
