import 'package:flutter/material.dart';

class AddTaskModel extends ChangeNotifier {
  bool isLoading = false;

  void beginLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask({
    @required String name,
  }) async {
    await Future.delayed(Duration(milliseconds: 3000));
  }
}
