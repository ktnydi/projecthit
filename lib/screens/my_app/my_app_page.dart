import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:projecthit/model/theme_model.dart';
import 'package:projecthit/screens/accept_invitation/accept_invitation_page.dart';
import 'package:projecthit/screens/auth/auth_page.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/project_list/project_list_page.dart';
import 'package:projecthit/theme/theme_data.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp({@required this.navigatorKey});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // インストール済みのとき
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final deepLink = dynamicLink?.link;
        if (deepLink != null) {
          widget.navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => AcceptInvitation(
                deepLink: deepLink,
              ),
            ),
            (route) => route.isFirst,
          );
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyAppModel>(
      create: (_) => MyAppModel(),
      builder: (context, child) {
        final myAppModel = context.read<MyAppModel>();

        return MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: widget.navigatorKey,
          theme: context.select((ThemeModel model) => model.isDarkMode)
              ? darkThemeData
              : lightThemeData,
          home: myAppModel.currentUser != null ? ProjectList() : Auth(),
        );
      },
    );
  }
}
