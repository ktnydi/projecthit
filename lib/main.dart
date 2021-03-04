import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/screens/auth/auth_page.dart';
import 'package:projecthit/theme/theme_data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final packageInfo = await PackageInfo.fromPlatform();

  runApp(
    MultiProvider(
      providers: [
        Provider<PackageInfo>.value(value: packageInfo),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      home: Auth(),
    );
  }
}
