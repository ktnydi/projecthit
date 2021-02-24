import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
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
    // TODO: 匿名認証の処理を追加
    await Future.delayed(
      Duration(milliseconds: 3000),
    );
  }
}
