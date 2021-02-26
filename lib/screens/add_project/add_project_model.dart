import 'package:flutter/material.dart';

class AddProjectModel extends ChangeNotifier {
  final deadlineController = TextEditingController();
  bool isActiveDateTime = false;
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

  Future<void> addProject({
    @required String name,
    @required DateTime deadline,
  }) async {
    await Future.delayed(Duration(milliseconds: 3000));
  }

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
