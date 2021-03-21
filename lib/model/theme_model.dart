import 'package:flutter/material.dart';
import 'package:projecthit/entity/app_setting.dart';
import 'package:projecthit/enum/appearance.dart';
import 'package:projecthit/repository/setting_repository.dart';
import 'package:projecthit/repository/user_repository.dart';

class ThemeModel extends ChangeNotifier {
  final _settingRepository = SettingRepository();
  final _userRepository = UserRepository();
  Appearance appearance = Appearance.light;

  bool get isDarkMode => appearance == Appearance.dark;

  void reload() {
    notifyListeners();
  }

  Future<void> fetchTheme() async {
    if (_userRepository.currentUser == null) return;

    final appSetting = await _settingRepository.fetchAppSetting();
    appearance = appSetting.isDark ? Appearance.dark : Appearance.light;
    notifyListeners();
  }

  Future<void> updateTheme(bool isDark) async {
    final appSetting = AppSetting();
    appSetting.isDark = isDark;
    await _settingRepository.updateAppSetting(appSetting);
  }
}
