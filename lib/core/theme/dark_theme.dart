import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  colorScheme: ColorScheme(
    brightness: Brightness.dark,

    primary: AppColors.primary,
    onPrimary: Colors.white,

    secondary: AppColors.secondary,
    onSecondary: Colors.white,

    error: AppColors.error,
    onError: Colors.white,

    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,

    primaryContainer: AppColors.primary.withValues(alpha: .20),
    onPrimaryContainer: Colors.white,

    secondaryContainer: AppColors.secondary.withValues(alpha: .20),
    onSecondaryContainer: Colors.white,

    errorContainer: AppColors.error.withValues(alpha: .20),
    onErrorContainer: Colors.white,

    surfaceContainerHighest: AppColors.darkDivider,

    outline: AppColors.darkDivider,

    shadow: Colors.black,

    inverseSurface: AppColors.lightSurface,
    onInverseSurface: AppColors.lightTextPrimary,

    inversePrimary: AppColors.primary,
    scrim: Colors.black87,
  ),

  scaffoldBackgroundColor: AppColors.darkBackground,
);
