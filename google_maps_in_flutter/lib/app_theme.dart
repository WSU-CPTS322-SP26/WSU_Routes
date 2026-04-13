import 'package:flutter/material.dart';

class AppTheme{
// Light and dark ColorSchemes made by FlexColorScheme v7.0.5.
// These ColorScheme objects require Flutter 3.7 or later.
static const ColorScheme customColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xffb00020),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffe1e1e1),
  onPrimaryContainer: Color(0xff131313),
  secondary: Color(0xff4d4d4d),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xff4e4e4e),
  onSecondaryContainer: Color(0xfff5f5f5),
  tertiary: Color(0xff1f3339),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xff95f0ff),
  onTertiaryContainer: Color(0xff0d1414),
  error: Color(0xffb00020),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffcd8df),
  onErrorContainer: Color(0xff141213),
  background: Color(0xfffcf8f8),
  onBackground: Color(0xff090909),
  surface: Color(0xfffcf8f8),
  onSurface: Color(0xff090909),
  surfaceVariant: Color(0xffeae0e2),
  onSurfaceVariant: Color(0xff121111),
  outline: Color(0xff7c7c7c),
  outlineVariant: Color(0xffc8c8c8),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff151011),
  onInverseSurface: Color(0xfff5f5f5),
  inversePrimary: Color(0xffff99ae),
  surfaceTint: Color(0xffb00020),
);

//acts as theming for main.dart and other pages
static ThemeData lightTheme = ThemeData(
  useMaterial3: false,

  colorScheme: customColorScheme,

  primaryColor: customColorScheme.primary,

  appBarTheme: AppBarTheme(
    backgroundColor: customColorScheme.primary,
    foregroundColor: customColorScheme.onPrimary,
  ),

  bottomAppBarTheme: BottomAppBarThemeData(
    color: customColorScheme.primary,
  ),
);


}
