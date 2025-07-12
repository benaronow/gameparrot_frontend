import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3); // Brighter blue
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color darkBlue = Color(0xFF0F3460); // Added dark blue
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color white = Colors.white;
  static const Color gray = Color(0xFFF5F7FA);
  static const Color darkGray = Color(0xFFB0BEC5);
  static const Color bubbleMe = primaryBlue;
  static const Color bubbleOther = lightBlue;
  static const Color background = white;
  static const Color textPrimary = Color(0xFF222222);
  static const Color textOnPrimary = white;
  static const Color textOnBubbleOther = Color(0xFF222222);

  // Enhanced 3D colors
  static const Color shadow = Color(0x40000000);
  static const Color lightShadow = Color(0x20000000);
  static const Color highlight = Color(0x30FFFFFF);
  static const Color deepShadow = Color(0x60000000);
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    secondary: AppColors.accentBlue,
    surface: AppColors.gray,
    onPrimary: AppColors.textOnPrimary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
  ),
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: AppColors.textOnPrimary,
    elevation: 2,
    titleTextStyle: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.textOnPrimary,
    ),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
      shadows: [
        Shadow(
          color: AppColors.lightShadow,
          offset: Offset(0, 2),
          blurRadius: 4,
        ),
        Shadow(
          color: AppColors.highlight,
          offset: Offset(0, -1),
          blurRadius: 2,
        ),
      ],
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
      shadows: [
        Shadow(
          color: AppColors.lightShadow,
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      shadows: [
        Shadow(color: AppColors.highlight, offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      color: AppColors.textPrimary,
      shadows: [
        Shadow(color: AppColors.highlight, offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary,
      shadows: [
        Shadow(color: AppColors.highlight, offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
      shadows: [
        Shadow(
          color: AppColors.lightShadow,
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style:
        ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: AppColors.textPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          elevation: 4,
          shadowColor: AppColors.shadow,
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.hovered)) {
              return AppColors.highlight;
            }
            if (states.contains(WidgetState.pressed)) {
              return AppColors.lightShadow;
            }
            return null;
          }),
        ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray,
    border: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: AppColors.lightBlue.withValues(alpha: 0.5),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(
        color: AppColors.lightBlue.withValues(alpha: 0.5),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade400, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    labelStyle: const TextStyle(
      color: AppColors.primaryBlue,
      shadows: [
        Shadow(color: AppColors.highlight, offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
    hintStyle: TextStyle(
      color: AppColors.darkGray.withValues(alpha: 0.7),
      shadows: const [
        Shadow(color: AppColors.highlight, offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  cardTheme: CardThemeData(
    color: AppColors.white,
    elevation: 6,
    shadowColor: AppColors.shadow,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      side: BorderSide(
        color: AppColors.lightBlue.withValues(alpha: 0.3),
        width: 1,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.accentBlue,
    foregroundColor: AppColors.textPrimary,
    elevation: 6,
    focusElevation: 8,
    hoverElevation: 8,
    highlightElevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  iconTheme: const IconThemeData(color: AppColors.primaryBlue, size: 28),
);
