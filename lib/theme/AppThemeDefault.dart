import 'package:flutter/material.dart';

class AppThemeDefault {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color accentColor;
  final Color additionalColor1;
  final Color additionalColor2;
  final Color additionalColor3;
  final Color textColor1;
  final Color textColor2;

  const AppThemeDefault(
      {Color? primaryColor,
      Color? secondaryColor,
      Color? tertiaryColor,
      Color? accentColor,
      Color? additionalColor1,
      Color? additionalColor2,
      Color? additionalColor3,
      Color? textColor1,
      Color? textColor2})
      : primaryColor = primaryColor ?? Colors.black,
        secondaryColor = secondaryColor ?? Colors.black,
        tertiaryColor = tertiaryColor ?? Colors.black,
        accentColor = accentColor ?? Colors.black,
        additionalColor1 = additionalColor1 ?? Colors.black,
        additionalColor2 = additionalColor2 ?? Colors.black,
        additionalColor3 = additionalColor3 ?? Colors.black,
        textColor1 = textColor1 ?? Colors.black,
        textColor2 = textColor2 ?? Colors.black;
}

extension ThemeDataExtensions on ThemeData {
  static final Map<InputDecorationTheme, AppThemeDefault> _appTheme = {};

  void addDefaultTheme(AppThemeDefault appTheme) {
    _appTheme[inputDecorationTheme] = appTheme;
  }

  static AppThemeDefault? empty;

  AppThemeDefault appDefault() {
    var appDefault = _appTheme[inputDecorationTheme];
    if (appDefault == null) {
      empty ??= const AppThemeDefault();
      appDefault = empty;
    }
    return appDefault!;
  }
}

AppThemeDefault appTheme(BuildContext context) =>
    Theme.of(context).appDefault();
