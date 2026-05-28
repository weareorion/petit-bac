import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
  final bool hasBorder;
  final double borderRadius;
  final double iconSize;
  final double fontSize;
  final double shadowOpacity;
  final Color? iconColor;
  final Border? customBorder;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
    this.hasBorder = false,
    this.borderRadius = 20,
    this.iconSize = 24,
    this.fontSize = 18,
    this.shadowOpacity = 0.2,
    this.iconColor,
    this.customBorder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBorder = customBorder ?? (hasBorder 
        ? Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)) 
        : null);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: resolvedBorder,
          boxShadow: !hasBorder ? [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(shadowOpacity),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? textColor, size: iconSize),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
