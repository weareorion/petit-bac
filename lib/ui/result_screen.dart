import 'package:flutter/material.dart';
import 'package:petit_bac/ui/correction_screen.dart';
import 'package:petit_bac/widgets/action_button.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalPossible;
  final int correctAnswers;
  final int errors;
  
  // Correction
  final String selectedLetter;
  final Map<String, String> userAnswers;
  final Map<String, bool> validationResults;

  const ResultScreen({
    super.key,
    this.score = 0,
    this.totalPossible = 70,
    this.correctAnswers = 0,
    this.errors = 0,
    this.selectedLetter = "",
    this.userAnswers = const {},
    this.validationResults = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const Color primaryColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Bouton Exit
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.grey, size: 24),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PARTIE TERMINÉE',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Indicateur de score circulaire
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: totalPossible > 0 ? score / totalPossible : 0,
                            strokeWidth: 12,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$score',
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                            ),
                            Text(
                              '/ $totalPossible PTS',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Stats Correct / Erreurs
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'CORRECT',
                            value: '$correctAnswers',
                            color: Colors.green,
                            bgColor: isDark ? Colors.green.withOpacity(0.15) : const Color(0xFFE8F5E9),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            label: 'ERREURS',
                            value: '$errors',
                            color: Colors.red,
                            bgColor: isDark ? Colors.red.withOpacity(0.15) : const Color(0xFFFFEBEE),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Bouton Voir la correction
                    ActionButton(
                      label: 'Voir la correction',
                      icon: Icons.assignment_turned_in_rounded,
                      color: theme.cardColor,
                      textColor: theme.textTheme.bodyLarge?.color ?? const Color(0xFF1A1D21),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CorrectionScreen(
                              selectedLetter: selectedLetter,
                              userAnswers: userAnswers,
                              validationResults: validationResults,
                            ),
                          ),
                        );
                      },
                      hasBorder: true,
                      iconColor: Colors.blueAccent,
                    ),

                    const SizedBox(height: 16),

                    // Bouton Rejouer
                    ActionButton(
                      label: 'REJOUER',
                      icon: Icons.refresh_rounded,
                      color: primaryColor,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/letter', (route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}