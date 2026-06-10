import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_colors.dart';
import 'package:petit_bac/core/constants/app_spacing.dart';
import 'package:petit_bac/core/constants/app_text_styles.dart';
import 'package:petit_bac/features/game/presentation/providers/game_session_provider.dart';
import 'package:petit_bac/ui/result_screen.dart';
import 'package:petit_bac/shared/widgets/exit_dialog.dart';
import 'package:petit_bac/shared/widgets/game_header.dart';
import 'package:petit_bac/shared/widgets/game_input_field.dart';
import 'package:petit_bac/shared/widgets/loading_overlay.dart';

class GameScreen extends StatefulWidget {
  final String selectedLetter;

  const GameScreen({super.key, required this.selectedLetter});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameSessionProvider _session;

  final Map<String, TextEditingController> _controllers = {
    "PAYS": TextEditingController(),
    "FRUITS": TextEditingController(),
    "VOITURES": TextEditingController(),
    "OBJET": TextEditingController(),
    "PRÉNOM FILLE": TextEditingController(),
    "PRÉNOM GARÇON": TextEditingController(),
    "ANIMAL": TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _session = GameSessionProvider.create(widget.selectedLetter);
    _session.startTimer(onTimeUp: _finishGame);
  }

  Map<String, String> _collectAnswers() {
    return {
      for (final entry in _controllers.entries) entry.key: entry.value.text,
    };
  }

  Future<void> _finishGame() async {
    final round = await _session.finishGame(_collectAnswers());
    if (!mounted || round == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(round: round),
      ),
    );
  }

  void _showExitDialog() {
    ExitDialog.show(context);
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _session.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog();
      },
      child: ListenableBuilder(
        listenable: _session,
        builder: (context, _) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: LoadingOverlay(
              isLoading: _session.isLoading,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      child: Row(
                        children: [
                          CircleIconButton(
                            icon: Icons.close,
                            onTap: _showExitDialog,
                          ),
                          const Spacer(),
                          HeaderIndicator(
                            label: "LETTRE",
                            value: widget.selectedLetter,
                            backgroundColor: Colors.blueAccent,
                            textColor: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          HeaderIndicator(
                            label: "TEMPS",
                            value: _formatTime(_session.secondsRemaining),
                            backgroundColor:
                                isDark ? theme.cardColor : Colors.white,
                            textColor: isDark ? Colors.white : Colors.black,
                            hasBorder: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      "C'est parti !",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.subtitle,
                        children: [
                          const TextSpan(
                            text: "Trouvez des mots commençant par la lettre ",
                          ),
                          TextSpan(
                            text: widget.selectedLetter,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.screenHorizontal),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenHorizontal,
                        ),
                        children: [
                          GameInputField(
                            label: "PAYS",
                            hint: "Entrez un pays...",
                            icon: Icons.public,
                            controller: _controllers["PAYS"]!,
                          ),
                          GameInputField(
                            label: "FRUITS",
                            hint: "Entrez un fruit...",
                            icon: Icons.restaurant,
                            controller: _controllers["FRUITS"]!,
                          ),
                          GameInputField(
                            label: "VOITURES",
                            hint: "Entrez une marque...",
                            icon: Icons.directions_car,
                            controller: _controllers["VOITURES"]!,
                          ),
                          GameInputField(
                            label: "OBJET",
                            hint: "Entrez un objet...",
                            icon: Icons.category,
                            controller: _controllers["OBJET"]!,
                          ),
                          GameInputField(
                            label: "PRÉNOM FILLE",
                            hint: "Entrez un prénom...",
                            icon: Icons.face_3,
                            controller: _controllers["PRÉNOM FILLE"]!,
                          ),
                          GameInputField(
                            label: "PRÉNOM GARÇON",
                            hint: "Entrez un prénom...",
                            icon: Icons.face,
                            controller: _controllers["PRÉNOM GARÇON"]!,
                          ),
                          GameInputField(
                            label: "ANIMAL",
                            hint: "Entrez un animal...",
                            icon: Icons.pets,
                            controller: _controllers["ANIMAL"]!,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                      child: ElevatedButton.icon(
                        onPressed: _session.isLoading ? null : _finishGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 64),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.stopButtonRadius,
                            ),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.danger.withOpacity(0.4),
                        ),
                        icon: const Icon(Icons.front_hand, size: 24),
                        label: const Text(
                          "STOP",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
