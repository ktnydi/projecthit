import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:projecthit/screens/my_app/my_app_page.dart';
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
