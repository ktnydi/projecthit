import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class SignInModel extends ChangeNotifier {
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

  Future<void> signInWithEmail({
    @required String email,
    @required String password,
  }) async {
    await _userRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
