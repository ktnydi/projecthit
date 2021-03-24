import 'package:flutter/material.dart';

const mainColor = Color(0xFF54B2E4);
const onMainColor = Color(0xFFFFFFFF);
const scaffoldBackgroundLightColor = Color(0xFFE6F4FB);
const scaffoldBackgroundDarkColor = Color(0xFF303030);
const dividerLightColor = Color(0x1F000000);
const dividerDarkColor = Color(0x1FFFFFFF);
const backgroundLightColor = Color(0xFFFFFFFF);
const backgroundDarkColor = Color(0xFF404040);

ThemeData lightThemeData = ThemeData.from(
  colorScheme: ColorScheme.light(
    primary: mainColor,
    onPrimary: onMainColor,
    secondary: mainColor,
    onSecondary: onMainColor,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
      fontSize: 18,
    ),
  ),
).copyWith(
  scaffoldBackgroundColor: scaffoldBackgroundLightColor,
  canvasColor: backgroundLightColor,
  splashColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    color: backgroundLightColor,
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: backgroundLightColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerLightColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerLightColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerLightColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

ThemeData darkThemeData = ThemeData.from(
  colorScheme: ColorScheme.dark(
    primary: mainColor,
    onPrimary: onMainColor,
    secondary: mainColor,
    onSecondary: onMainColor,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
      fontSize: 18,
    ),
  ),
).copyWith(
  scaffoldBackgroundColor: scaffoldBackgroundDarkColor,
  canvasColor: backgroundDarkColor,
  splashColor: Colors.transparent,
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: TextStyle(
        fontSize: 16,
      ),
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: backgroundDarkColor,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerDarkColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerDarkColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: dividerDarkColor,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
