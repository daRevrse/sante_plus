import 'package:flutter/material.dart';

class MyThemes{
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade900,
      ),
      colorScheme: ColorScheme.dark()
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        color: Colors.white,
      ),
      colorScheme: ColorScheme.light()
  );
}