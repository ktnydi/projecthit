import 'package:flutter/material.dart';

class SignInModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithEmail() async {
    // TODO: サインイン処理を追加
    await Future.delayed(
      Duration(milliseconds: 3000),
    );
  }
}
