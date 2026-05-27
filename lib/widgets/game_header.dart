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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder
                ? Border.all(color: Colors.black.withOpacity(0.05))
                : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
