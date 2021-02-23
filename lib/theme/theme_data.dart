import 'package:flutter/material.dart';

final lightThemeData = ThemeData.from(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF65AA74),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF65AA74),
    onSecondary: Color(0xFFFFFFFF),
  ),
).copyWith(
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
);

final darkThemeData = ThemeData.from(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF65AA74),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF65AA74),
    onSecondary: Color(0xFFFFFFFF),
  ),
).copyWith(
  scaffoldBackgroundColor: Color(0xFF202020),
);
