import 'package:flutter/material.dart';

ThemeData lightThemeData = ThemeData.from(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF65AA74),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF65AA74),
    onSecondary: Color(0xFFFFFFFF),
  ),
).copyWith(
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  canvasColor: Color(0xFFFFFFFF),
  appBarTheme: AppBarTheme(
    color: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Typography.material2014().black.headline6.color,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Typography.material2014().black.headline6.color,
      ),
    ),
  ),
);

ThemeData darkThemeData = ThemeData.from(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF65AA74),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF65AA74),
    onSecondary: Color(0xFFFFFFFF),
  ),
).copyWith(
  scaffoldBackgroundColor: Color(0xFF202020),
  canvasColor: Color(0xFF202020),
  appBarTheme: AppBarTheme(
    color: Color(0xFF202020),
    brightness: Brightness.dark,
    elevation: 0,
    iconTheme: IconThemeData(
      color: Typography.material2014().white.headline6.color,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Typography.material2014().white.headline6.color,
      ),
    ),
  ),
);
