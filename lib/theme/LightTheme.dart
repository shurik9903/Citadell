import 'package:flutter/material.dart';

import 'AppThemeDefault.dart';

class LightTheme {
  ThemeData get theme => ThemeData.light().copyWith()
    ..addDefaultTheme(
      const AppThemeDefault(
        primaryColor: Color.fromARGB(255, 218, 218, 218),
        secondaryColor: Color.fromARGB(255, 184, 184, 184),
        tertiaryColor: Color.fromARGB(255, 136, 136, 136),
        accentColor: Color.fromARGB(255, 255, 255, 255),
        additionalColor1: Color.fromARGB(255, 255, 255, 255),
        additionalColor2: Color.fromARGB(255, 255, 255, 255),
        additionalColor3: Color.fromARGB(255, 0, 0, 0),
        textColor1: Color.fromARGB(255, 255, 255, 255),
        textColor2: Color.fromARGB(255, 255, 255, 255),
      ),
    );
}
