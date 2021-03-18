import 'package:flutter/material.dart';

class AcceptInvitationModel extends ChangeNotifier {
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addProject(Uri deepLink) async {
    // TODO: 招待されたプロジェクトを追加する。
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
