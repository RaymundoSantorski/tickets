import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.primary,
    onPrimary: Colors.white,

    secondary: AppColors.secondary,
    onSecondary: Colors.white,

    error: AppColors.error,
    onError: Colors.white,

    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,

    primaryContainer: AppColors.primary.withValues(alpha: .15),
    onPrimaryContainer: AppColors.primary,

    secondaryContainer: AppColors.secondary.withValues(alpha: .15),
    onSecondaryContainer: AppColors.secondary,

    errorContainer: AppColors.error.withValues(alpha: .15),
    onErrorContainer: AppColors.error,

    surfaceContainerHighest: AppColors.lightDivider,

    outline: AppColors.lightDivider,

    shadow: Colors.black26,

    inverseSurface: AppColors.darkSurface,
    onInverseSurface: Colors.white,

    inversePrimary: AppColors.primary,
    scrim: Colors.black54,
  ),

  scaffoldBackgroundColor: AppColors.lightBackground,
);
