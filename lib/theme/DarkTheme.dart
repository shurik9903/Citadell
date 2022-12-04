import 'package:flutter/material.dart';

import 'AppThemeDefault.dart';

class DarkTheme {
  ThemeData get theme => ThemeData.dark().copyWith()
    ..addDefaultTheme(
      const AppThemeDefault(
        primaryColor: Color.fromARGB(255, 34, 34, 34),
        secondaryColor: Color.fromARGB(255, 51, 51, 51),
        tertiaryColor: Color.fromARGB(255, 107, 107, 107),
        accentColor: Color.fromARGB(255, 0, 0, 0),
        additionalColor1: Color.fromARGB(255, 64, 255, 57),
        additionalColor2: Color.fromARGB(255, 0, 0, 0),
        additionalColor3: Color.fromARGB(255, 255, 255, 255),
        textColor1: Color.fromARGB(255, 255, 255, 255),
        textColor2: Color.fromARGB(255, 0, 0, 0),
      ),
    );
}
