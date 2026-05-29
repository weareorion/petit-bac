import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_colors.dart';
import 'package:petit_bac/core/constants/app_spacing.dart';
import 'package:petit_bac/widgets/action_button.dart';
import 'package:petit_bac/widgets/game_header.dart';
import 'package:petit_bac/widgets/letter_wheel.dart';
import 'package:petit_bac/ui/game_screen.dart';

class LetterSpin extends StatefulWidget {
  const LetterSpin({super.key});

  @override
  State<LetterSpin> createState() => _LetterSpinState();
}

class _LetterSpinState extends State<LetterSpin> {
  final List<String> _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  String _currentLetter = 'A';
  bool _isSpinning = true;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startSpinning();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSpinning() {
    _timer?.cancel();
    setState(() {
      _isSpinning = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _currentLetter = _alphabet[_random.nextInt(_alphabet.length)];
      });
    });
  }

  void _stopSpinning() {
    _timer?.cancel();
    setState(() {
      _isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    const Color primaryColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'PETIT BAC',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 48), 
                ],
              ),
              
              const Spacer(flex: 2),

              Text(
                _isSpinning ? 'C\'est parti !' : 'Lettre choisie : $_currentLetter',
                style: TextStyle(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isSpinning 
                  ? 'Arrêtez la roue pour choisir votre lettre'
                  : 'Voulez-vous jouer avec cette lettre ?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const Spacer(flex: 3),

              Center(
                child: LetterWheel(letter: _currentLetter),
              ),

              const Spacer(flex: 4),

              // Boutons d'action dynamiques
              if (_isSpinning)
                ActionButton(
                  label: 'Arrêter',
                  icon: Icons.stop_circle_outlined,
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: _stopSpinning,
                  borderRadius: 16,
                  iconSize: 28,
                  fontSize: 20,
                  shadowOpacity: 0.3,
                )
              else ...[
                ActionButton(
                  label: 'Commencer la partie',
                  icon: Icons.play_arrow_rounded,
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScreen(selectedLetter: _currentLetter),
                      ),
                    );
                  },
                  borderRadius: 16,
                  iconSize: 28,
                  fontSize: 20,
                  shadowOpacity: 0.3,
                ),
                const SizedBox(height: 12),
                ActionButton(
                  label: 'Relancer la roue',
                  icon: Icons.refresh_rounded,
                  color: theme.cardColor,
                  textColor: primaryColor,
                  onTap: _startSpinning,
                  hasBorder: true,
                  borderRadius: 16,
                  iconSize: 28,
                  fontSize: 20,
                  shadowOpacity: 0.3,
                  customBorder: Border.all(color: isDark ? Colors.white24 : Colors.blueAccent, width: 2),
                ),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.textGrey.withOpacity(0.7), size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'GÉNÉRATEUR ALÉATOIRE',
                    style: TextStyle(
                      color: AppColors.textGrey.withOpacity(0.7),
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}