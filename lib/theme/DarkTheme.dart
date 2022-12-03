import 'package:flutter/material.dart';

import 'AppThemeDefault.dart';

class DarkTheme {
  ThemeData get theme => ThemeData.dark().copyWith()
    ..addDefaultTheme(
      const AppThemeDefault(
        primaryColor: Color.fromARGB(255, 141, 141, 141),
        secondaryColor: Color.fromARGB(255, 75, 75, 75),
        tertiaryColor: Color.fromARGB(255, 48, 48, 48),
        accentColor: Color.fromARGB(255, 27, 27, 27),
        additionalColor1: Color.fromARGB(255, 64, 255, 57),
        additionalColor2: Color.fromARGB(255, 0, 0, 0),
        additionalColor3: Color.fromARGB(255, 255, 255, 255),
        textColor1: Color.fromARGB(255, 255, 255, 255),
        textColor2: Color.fromARGB(255, 0, 0, 0),
      ),
    );
}
