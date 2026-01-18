import 'package:flutter/material.dart';
import 'package:safe_opensig/core/theme/theme_config.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ThemeConfig.primary,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: ThemeConfig.primary,
      primary: ThemeConfig.primary,
      onPrimary: ThemeConfig.onPrimary,
      secondary: ThemeConfig.secondary,
      onSecondary: ThemeConfig.onSecondary,
      error: ThemeConfig.error,
      onError: ThemeConfig.onError,
      surface: ThemeConfig.surface,
      onSurface: ThemeConfig.onSurface,
    ),
    scaffoldBackgroundColor: ThemeConfig.background,
    textTheme: ThemeConfig.textTheme,
    elevatedButtonTheme: ThemeConfig.elevatedButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ThemeConfig.secondaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ThemeConfig.textButtonStyle,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConfig.borderRadiusLarge,
      ),
      elevation: 8,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ThemeConfig.darkPrimary,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: ThemeConfig.darkPrimary,
      primary: ThemeConfig.darkPrimary,
      onPrimary: ThemeConfig.darkOnPrimary,
      secondary: ThemeConfig.darkSecondary,
      onSecondary: ThemeConfig.darkOnSecondary,
      error: ThemeConfig.darkError,
      onError: ThemeConfig.darkOnError,
      surface: ThemeConfig.darkSurface,
      onSurface: ThemeConfig.darkOnSurface,
    ),
    scaffoldBackgroundColor: ThemeConfig.darkBackground,
    textTheme: ThemeConfig.textTheme,
    elevatedButtonTheme: ThemeConfig.darkElevatedButtonTheme,
    floatingActionButtonTheme: ThemeConfig.darkFloatingActionButtonTheme,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ThemeConfig.secondaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ThemeConfig.textButtonStyle,
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConfig.borderRadiusLarge,
      ),
      elevation: 8,
    ),
  );
}

