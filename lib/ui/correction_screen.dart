import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_colors.dart';
import 'package:petit_bac/core/constants/app_spacing.dart';
import 'package:petit_bac/core/constants/app_text_styles.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/features/game/domain/entities/answer.dart';
import 'package:petit_bac/features/game/domain/entities/round.dart';

class CorrectionScreen extends StatelessWidget {
  final Round round;

  const CorrectionScreen({
    super.key,
    required this.round,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final correctAnswers =
        round.answers.where((answer) => answer.isValid).toList();
    final incorrectAnswers =
        round.answers.where((answer) => !answer.isValid).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Correction',
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppSpacing.navMargin),
            padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadiusLg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat(
                  "Lettre choisie",
                  round.letter,
                  AppColors.primaryPurple,
                ),
                _buildHeaderStat(
                  "Score final",
                  "${round.totalScore}/${round.totalPossible}",
                  AppColors.primaryPurple,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.navMargin,
              ),
              children: [
                _buildSectionTitle(
                  context,
                  "Bonnes Réponses",
                  Icons.check_circle_outline,
                  AppColors.success,
                  "+${round.totalScore} pts",
                ),
                ...correctAnswers.map(
                  (answer) => _buildCorrectionCard(context, answer),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(
                  context,
                  "Mauvaises Réponses",
                  Icons.highlight_off,
                  AppColors.error,
                  "0 pts",
                ),
                ...incorrectAnswers.map(
                  (answer) => _buildCorrectionCard(context, answer),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.letter,
            (route) => false,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPurple,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
            ),
          ),
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text(
            "REJOUER",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withOpacity(0.8), fontSize: 14),
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
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String points,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const Spacer(),
          Text(
            points,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionCard(BuildContext context, Answer answer) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isValid = answer.isValid;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.mdCompact),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
        border: Border.all(
          color: isValid
              ? Colors.green.withOpacity(isDark ? 0.3 : 0.2)
              : Colors.red.withOpacity(isDark ? 0.3 : 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(answer.categoryId, style: AppTextStyles.categoryLabel),
                const SizedBox(height: 4),
                Text(
                  answer.value.isEmpty ? "Pas de réponse" : answer.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: answer.value.isEmpty
                        ? Colors.grey
                        : (isValid
                            ? (isDark ? Colors.white : Colors.black)
                            : Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isValid
                  ? Colors.green.withOpacity(isDark ? 0.2 : 0.1)
                  : Colors.red.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              isValid ? "+${answer.points}" : "0",
              style: TextStyle(
                color: isValid ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
