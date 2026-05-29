import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_colors.dart';
import 'package:petit_bac/core/constants/app_text_styles.dart';

/// Light and dark [ThemeData] for the app.
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
          background: AppColors.scaffoldLight,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldLight,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: AppTextStyles.appBarTitleLight,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
          background: AppColors.scaffoldDark,
          surface: AppColors.surfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.scaffoldDark,
        cardColor: AppColors.surfaceDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: AppTextStyles.appBarTitleDark,
        ),
      );
}
