import 'package:flutter/material.dart';

class ForgotPasswordModel extends ChangeNotifier {
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
    // TODO: send password reset email.
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
