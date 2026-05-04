import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalPossible;
  final int correctAnswers;
  final int errors;

  const ResultScreen({
    super.key,
    this.score = 65,
    this.totalPossible = 70,
    this.correctAnswers = 13,
    this.errors = 1,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Colors.blueAccent;
    const Color backgroundGrey = Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: backgroundGrey,
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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.05),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.grey,
                        size: 24,
                      ),
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

                    // Indicateur de score
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: score / totalPossible,
                            strokeWidth: 12,
                            backgroundColor: primaryColor.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1D21),
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

                    //  Correct / Erreurs
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'CORRECT',
                            value: '$correctAnswers',
                            color: Colors.green,
                            bgColor: const Color(0xFFE8F5E9),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            label: 'ERREURS',
                            value: '$errors',
                            color: Colors.red,
                            bgColor: const Color(0xFFFFEBEE),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    //  Voir la correction
                    _buildActionButton(
                      label: 'Voir la correction',
                      icon: Icons.assignment_turned_in_rounded,
                      color: Colors.white,
                      textColor: const Color(0xFF1A1D21),
                      onTap: () {
                        // Action correction
                      },
                      hasBorder: true,
                    ),

                    const SizedBox(height: 16),

                    // Bouton Rejouer
                    _buildActionButton(
                      label: 'REJOUER',
                      icon: Icons.refresh_rounded,
                      color: primaryColor,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                        Navigator.pushNamed(context, '/letter');
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
              color: color.withOpacity(0.7),
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
          borderRadius: BorderRadius.circular(20),
          border: hasBorder
              ? Border.all(color: Colors.black.withOpacity(0.05))
              : null,
          boxShadow: !hasBorder
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: hasBorder ? Colors.blueAccent : textColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
