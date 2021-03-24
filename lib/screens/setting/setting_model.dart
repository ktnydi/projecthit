import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class SettingModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  bool isPermitNotification = false;
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void reload() {
    notifyListeners();
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
