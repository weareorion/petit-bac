import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_spacing.dart';
import 'package:petit_bac/core/constants/app_text_styles.dart';

class GameInputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;

  const GameInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.inputFieldBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.cardLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: controller,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: isDark ? Colors.white30 : Colors.black26),
              filled: true,
              fillColor: theme.cardColor,
              suffixIcon: Icon(
                icon,
                color: isDark ? Colors.white30 : Colors.black26,
                size: 22,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: isDark ? BorderSide(color: Colors.white.withOpacity(0.05), width: 1) : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: isDark ? BorderSide(color: Colors.white.withOpacity(0.05), width: 1) : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

