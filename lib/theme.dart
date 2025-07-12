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
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryBlue,
    ),
    bodyLarge: TextStyle(fontSize: 18, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textPrimary),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accentBlue,
      foregroundColor: AppColors.textPrimary,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      elevation: 2,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    labelStyle: TextStyle(color: AppColors.primaryBlue),
  ),
  cardTheme: const CardThemeData(
    color: AppColors.white,
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accentBlue,
    foregroundColor: AppColors.textPrimary,
    elevation: 3,
  ),
  iconTheme: const IconThemeData(color: AppColors.primaryBlue, size: 28),
);
