import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'GameScreen.dart';

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
    const Color primaryColor = Colors.blueAccent;
    const Color backgroundGrey = Color(0xFFF8F9FB);
    const Color textGrey = Color(0xFF8A94A6);

    return Scaffold(
      backgroundColor: backgroundGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textGrey, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'PETIT BAC',
                    style: TextStyle(
                      color: textGrey,
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
                style: const TextStyle(
                  color: Color(0xFF1A1D21),
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
                  color: textGrey,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const Spacer(flex: 3),

              Center(
                child: Stack(
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
                        color: Colors.white,
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
                      _currentLetter,
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 140,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 4),

              // Boutons d'action dynamiques
              if (_isSpinning)
                _buildActionButton(
                  label: 'Arrêter',
                  icon: Icons.stop_circle_outlined,
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: _stopSpinning,
                )
              else ...[
                _buildActionButton(
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
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  label: 'Relancer la roue',
                  icon: Icons.refresh_rounded,
                  color: Colors.white,
                  textColor: primaryColor,
                  onTap: _startSpinning,
                  hasBorder: true,
                ),
              ],

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, color: textGrey.withOpacity(0.7), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'GÉNÉRATEUR ALÉATOIRE',
                    style: TextStyle(
                      color: textGrey.withOpacity(0.7),
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

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool hasBorder = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: hasBorder ? Border.all(color: Colors.blueAccent, width: 2) : null,
          boxShadow: !hasBorder ? [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}