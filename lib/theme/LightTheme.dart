import 'package:flutter/material.dart';

import 'AppThemeDefault.dart';

class LightTheme {
  ThemeData get theme => ThemeData.light().copyWith()
    ..addDefaultTheme(
      const AppThemeDefault(
        primaryColor: Color.fromARGB(255, 230, 230, 230),
        secondaryColor: Color.fromARGB(255, 201, 201, 201),
        tertiaryColor: Color.fromARGB(255, 146, 146, 146),
        accentColor: Color.fromARGB(255, 255, 255, 255),
        additionalColor1: Color.fromARGB(255, 255, 255, 255),
        additionalColor2: Color.fromARGB(255, 255, 255, 255),
        additionalColor3: Color.fromARGB(255, 0, 0, 0),
        textColor1: Color.fromARGB(255, 255, 255, 255),
        textColor2: Color.fromARGB(255, 255, 255, 255),
      ),
    );
}
