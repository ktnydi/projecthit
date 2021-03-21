import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class ForgotPasswordModel extends ChangeNotifier {
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

  Future<void> sendPasswordResetEmail(String email) async {
    await _userRepository.sendPasswordResetEmail(email);
  }
}
