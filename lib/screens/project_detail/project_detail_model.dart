import 'package:flutter/material.dart';

class ProjectDetailModel extends ChangeNotifier {
  final deadlineController = TextEditingController();
  bool isLoading = false;
  bool isActiveDateTime = false;

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

  @override
  void dispose() {
    deadlineController.dispose();
    super.dispose();
  }
}
