import 'package:flutter/material.dart';

class LetterWheel extends StatelessWidget {
  final String letter;

  const LetterWheel({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color primaryColor = Colors.blueAccent;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            color: theme.cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 4),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Text(
          letter,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 140,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
