import 'package:flutter/material.dart';
import 'package:projecthit/enum/appearance.dart';

class SettingModel extends ChangeNotifier {
  bool isPermitNotification = false;
  Appearance appearance = Appearance.light;

  bool get isDarkMode => appearance == Appearance.dark;

  void reload() {
    notifyListeners();
  }
}
