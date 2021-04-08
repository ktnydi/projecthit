import 'package:projecthit/entity/app_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  Future<void> updateAppSetting(AppSetting appSetting) async {
    final pref = await SharedPreferences.getInstance();

    await pref.setBool('isDark', appSetting.isDark);
  }

  Future<AppSetting> fetchAppSetting() async {
    final pref = await SharedPreferences.getInstance();
    return AppSetting()..isDark = pref.getBool('isDark') ?? false;
  }
}
