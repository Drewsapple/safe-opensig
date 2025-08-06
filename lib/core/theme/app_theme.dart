import 'package:flutter/material.dart';
import 'package:safe_verify/core/theme/theme_config.dart';

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
      background: ThemeConfig.background,
      onBackground: ThemeConfig.onBackground,
      surface: ThemeConfig.surface,
      onSurface: ThemeConfig.onSurface,
    ),
    scaffoldBackgroundColor: ThemeConfig.background,
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeConfig.primary,
      foregroundColor: ThemeConfig.onPrimary,
      titleTextStyle: ThemeConfig.textTheme.titleLarge?.copyWith(
        color: ThemeConfig.onPrimary,
      ),
    ),
    textTheme: ThemeConfig.textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ThemeConfig.primaryButtonStyle.copyWith(
        backgroundColor: WidgetStateProperty.all(ThemeConfig.primary),
        foregroundColor: WidgetStateProperty.all(ThemeConfig.onPrimary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ThemeConfig.secondaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ThemeConfig.textButtonStyle,
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
      background: ThemeConfig.darkBackground,
      onBackground: ThemeConfig.darkOnBackground,
      surface: ThemeConfig.darkSurface,
      onSurface: ThemeConfig.darkOnSurface,
    ),
    scaffoldBackgroundColor: ThemeConfig.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeConfig.darkPrimary,
      foregroundColor: ThemeConfig.darkOnPrimary,
      titleTextStyle: ThemeConfig.textTheme.titleLarge?.copyWith(
        color: ThemeConfig.darkOnPrimary,
      ),
    ),
    textTheme: ThemeConfig.textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ThemeConfig.primaryButtonStyle.copyWith(
        backgroundColor: WidgetStateProperty.all(ThemeConfig.darkPrimary),
        foregroundColor: WidgetStateProperty.all(ThemeConfig.darkOnPrimary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ThemeConfig.secondaryButtonStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ThemeConfig.textButtonStyle,
    ),
  );
}