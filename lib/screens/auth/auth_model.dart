import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class AuthModel extends ChangeNotifier {
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

  Future<void> signUpWithAnonymous() async {
    await _userRepository.signInAnonymous();
  }
}
