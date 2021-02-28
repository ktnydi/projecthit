import 'package:flutter/material.dart';

class TaskDetailModel extends ChangeNotifier {
  final deadlineController = TextEditingController();
  bool isActiveDateTime = false;

  void reload() {
    notifyListeners();
  }

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
