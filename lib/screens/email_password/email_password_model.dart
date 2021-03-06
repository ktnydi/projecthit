import 'package:flutter/material.dart';
import 'package:projecthit/repository/user_repository.dart';

class EmailPasswordModel extends ChangeNotifier {
  final _userRepository = UserRepository();
  bool isObscure = true;
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

  Future<void> signUpWithEmail({
    @required String email,
    @required String password,
  }) async {
    await _userRepository.linkWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateEmail({
    @required String email,
    @required String password,
  }) async {
    await _userRepository.updateEmail(email: email, password: password);
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
  }
}
