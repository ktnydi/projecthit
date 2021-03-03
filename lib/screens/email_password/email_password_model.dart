import 'package:flutter/material.dart';

class EmailPasswordModel extends ChangeNotifier {
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
    // TODO: サインアップする
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
