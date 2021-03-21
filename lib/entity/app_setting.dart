import 'package:projecthit/entity/app_setting_field.dart';

class AppSetting {
  bool isDark;

  AppSetting();

  AppSetting.fromMap(Map<String, dynamic> map) {
    isDark = map[AppSettingField.isDark];
  }

  Map<String, dynamic> toMap() {
    return {
      AppSettingField.isDark: isDark ?? false,
    };
  }
}
