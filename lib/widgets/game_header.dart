import 'package:flutter/material.dart';


class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        shape: BoxShape.circle,
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF8A94A6), size: 20),
        onPressed: onTap,
      ),
    );
  }
}

// Indicateur lettre ou temps
class HeaderIndicator extends StatelessWidget {
  final String label;
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final bool hasBorder;

  const HeaderIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Si on a un fond blanc codé en dur, on le remplace par le cardColor en mode sombre
    final resolvedBgColor = (backgroundColor == Colors.white && isDark)
        ? theme.cardColor
        : backgroundColor;

    // Si on a un texte noir codé en dur, on l'adapte
    final resolvedTextColor = (textColor == Colors.black && isDark)
        ? Colors.white
        : textColor;

    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8A94A6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: resolvedBgColor,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder
                ? Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))
                : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: resolvedTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
