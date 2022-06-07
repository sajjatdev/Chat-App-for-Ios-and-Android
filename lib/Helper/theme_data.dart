import 'package:chatting/Helper/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mytheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: HexColor.fromHex("#ffffff"),
      foregroundColor: Colors.black,
    ),
    colorScheme: const ColorScheme.dark(),
    bottomAppBarColor: Colors.black,
    shadowColor: HexColor.fromHex('#5F5F62'),
    iconTheme: const IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: HexColor.fromHex("#eff3f6"),
    primaryColor: Colors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HexColor.fromHex("#1a1a1c"),
        foregroundColor: Colors.white),
    secondaryHeaderColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    shadowColor: HexColor.fromHex('#5F5F62'),
    bottomAppBarColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  );
}
