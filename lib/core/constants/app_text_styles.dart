import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable [TextStyle] definitions used across multiple widgets.
class AppTextStyles {
  AppTextStyles._();

  static const cardLabel = TextStyle(
    color: AppColors.textGrey,
    fontSize: 11,
    fontWeight: FontWeight.bold,
  );

  static const headerLabel = TextStyle(
    color: AppColors.textGrey,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

  static const exitDialogBody = TextStyle(
    fontSize: 14,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const exitDialogSecondaryButton = TextStyle(
    color: AppColors.textGrey,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const appBarTitleLight = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const appBarTitleDark = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const subtitle = TextStyle(
    color: AppColors.textGrey,
    fontSize: 15,
  );

  static const categoryLabel = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );
}
