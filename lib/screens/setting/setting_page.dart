import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/enum/appearance.dart';
import 'package:projecthit/screens/profile/profile_page.dart';
import 'package:projecthit/screens/setting/setting_model.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (_) => SettingModel(),
      builder: (context, child) {
        final settingModel = context.read<SettingModel>();
        final packageInfo = context.read<PackageInfo>();

        return Scaffold(
          appBar: AppBar(
            title: Text('Setting'),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                ListTile(
                  title: Text('Profile'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Dark mode'),
                  trailing: Switch.adaptive(
                    value: context.select(
                      (SettingModel model) => model.isDarkMode,
                    ),
                    onChanged: (isActive) {
                      settingModel.appearance =
                          isActive ? Appearance.dark : Appearance.light;
                      settingModel.reload();

                      // TODO: ダークモード
                    },
                  ),
                ),
                ListTile(
                  title: Text('Notification'),
                  trailing: Switch.adaptive(
                    value: context.select(
                      (SettingModel model) => model.isPermitNotification,
                    ),
                    onChanged: (isActive) {
                      settingModel.isPermitNotification = isActive;
                      settingModel.reload();

                      // TODO: 通知許可
                    },
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'About',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                ListTile(
                  title: Text('Inquiry'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: お問い合わせフォームを表示
                  },
                ),
                ListTile(
                  title: Text('Review'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: レビュー画面を表示
                  },
                ),
                ListTile(
                  title: Text('Terms'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: 利用規約を表示
                  },
                ),
                ListTile(
                  title: Text('Privacy policy'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: プライバシーポリシーを表示
                  },
                ),
                ListTile(
                  title: Text('Version'),
                  trailing: Text('${packageInfo.version}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
