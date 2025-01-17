import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/implements/project_repository_impl.dart';
import 'package:projecthit/implements/task_repository_impl.dart';
import 'package:projecthit/implements/user_project_repository_impl.dart';
import 'package:projecthit/model/theme_model.dart';
import 'package:projecthit/repository/project_repository.dart';
import 'package:projecthit/repository/task_repository.dart';
import 'package:projecthit/repository/user_project_repository.dart';
import 'package:projecthit/screens/accept_invitation/accept_invitation_page.dart';
import 'package:projecthit/screens/my_app/my_app_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final navigatorKey = GlobalKey<NavigatorState>();
  final packageInfo = await PackageInfo.fromPlatform();
  final themeModel = ThemeModel();
  await themeModel.fetchTheme();

  // 未インストールのとき
  final data = await FirebaseDynamicLinks.instance.getInitialLink();
  final deepLink = data?.link;
  if (deepLink != null) {
    navigatorKey.currentState.push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AcceptInvitation(
          deepLink: deepLink,
        ),
      ),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<PackageInfo>.value(value: packageInfo),
        ChangeNotifierProvider<ThemeModel>(create: (_) => themeModel),
        Provider<TaskRepository>(
          create: (_) => TaskRepositoryImpl(),
        ),
        Provider<UserProjectRepository>(
            create: (_) => UserProjectRepositoryImpl()),
        Provider<ProjectRepository>(create: (_) => ProjectRepositoryImpl()),
      ],
      child: MyApp(navigatorKey: navigatorKey),
    ),
  );
}
