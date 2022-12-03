import 'package:flutter/material.dart';

import 'AppThemeDefault.dart';

class LightTheme {
  ThemeData get theme => ThemeData.light().copyWith()
    ..addDefaultTheme(
      const AppThemeDefault(
        primaryColor: Color.fromARGB(255, 255, 255, 255),
        secondaryColor: Color.fromARGB(255, 224, 224, 224),
        tertiaryColor: Color.fromARGB(255, 173, 173, 173),
        accentColor: Color.fromARGB(255, 255, 255, 255),
        additionalColor1: Color.fromARGB(255, 255, 255, 255),
        additionalColor2: Color.fromARGB(255, 255, 255, 255),
        additionalColor3: Color.fromARGB(255, 255, 255, 255),
        textColor1: Color.fromARGB(255, 255, 255, 255),
        textColor2: Color.fromARGB(255, 255, 255, 255),
      ),
    );
}
