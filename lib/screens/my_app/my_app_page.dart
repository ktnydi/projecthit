import 'package:flutter/material.dart';
import 'package:projecthit/screens/auth/auth_page.dart';
import 'package:projecthit/screens/my_app/my_app_model.dart';
import 'package:projecthit/screens/project_list/project_list_page.dart';
import 'package:projecthit/theme/theme_data.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyAppModel>(
      create: (_) => MyAppModel(),
      builder: (context, child) {
        final myAppModel = context.read<MyAppModel>();

        return MaterialApp(
          title: 'Flutter Demo',
          theme: lightThemeData,
          darkTheme: darkThemeData,
          home: myAppModel.currentUser != null ? ProjectList() : Auth(),
        );
      },
    );
  }
}
