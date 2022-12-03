import 'package:flutter/material.dart';

import 'DarkTheme.dart';
import 'LightTheme.dart';

enum EnumTheme { dark, light }

class ThemeFactory {
  ThemeData themeCreator(EnumTheme eTheme) {
    switch (eTheme) {
      case EnumTheme.dark:
        return DarkTheme().theme;
      case EnumTheme.light:
        return LightTheme().theme;
      default:
        return LightTheme().theme;
    }
  }
}
