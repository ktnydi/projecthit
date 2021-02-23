import 'package:flutter/material.dart';
import 'package:projecthit/screens/auth_page.dart';
import 'package:projecthit/theme/theme_data.dart';

void main() {
  runApp(MyApp());
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
