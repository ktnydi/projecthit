import 'package:flutter/material.dart';

class SettingModel extends ChangeNotifier {
  bool isPermitNotification = false;

  void reload() {
    notifyListeners();
  }
}
