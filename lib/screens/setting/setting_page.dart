import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/enum/appearance.dart';
import 'package:projecthit/model/theme_model.dart';
import 'package:projecthit/screens/auth/auth_page.dart';
import 'package:projecthit/screens/email_password/email_password_page.dart';
import 'package:projecthit/screens/inquiry/inquiry_page.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/profile/profile_page.dart';
import 'package:projecthit/screens/setting/setting_model.dart';
import 'package:provider/provider.dart';

class Setting extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final myAppModel = context.read<MyAppModel>();
    final settingModel = context.read<SettingModel>();

    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign out'),
            content: Text('Thank you for using this app. Do you sign out?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Sign out'),
                onPressed: () async {
                  settingModel.beginLoading();
                  await settingModel.signOut();
                  settingModel.endLoading();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Auth(),
                    ),
                    (route) => route.isFirst,
                  );
                  await myAppModel.fetchCurrentUser();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      settingModel.endLoading();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Oops!'),
            content: Text('$e'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (_) => SettingModel(),
      builder: (context, child) {
        final settingModel = context.read<SettingModel>();
        final packageInfo = context.read<PackageInfo>();
        final themeModel = context.read<ThemeModel>();
        final myAppModel = context.read<MyAppModel>();

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
                  title: Text('Email & Password'),
                  subtitle: Text(myAppModel.currentUser?.email ?? 'Anonymous'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailPassword(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Dark mode'),
                  trailing: Switch.adaptive(
                    value: context.select(
                      (ThemeModel model) => model.isDarkMode,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (isActive) {
                      themeModel.appearance =
                          isActive ? Appearance.dark : Appearance.light;
                      themeModel.reload();
                      themeModel.updateTheme(isActive);
                    },
                  ),
                ),
                ListTile(
                  title: Text('Notification'),
                  trailing: Switch.adaptive(
                    value: context.select(
                      (SettingModel model) => model.isPermitNotification,
                    ),
                    activeColor: Theme.of(context).colorScheme.secondary,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Inquiry(),
                      ),
                    );
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
                SizedBox(height: 32),
                if (!myAppModel.currentUser.isAnonymous)
                  Center(
                    child: ElevatedButton(
                      child: Text('Sign out'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(160, 44),
                      ),
                      onPressed: () async {
                        await _signOut(context);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
