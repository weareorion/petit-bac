import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petit_bac/services/wikipedia_service.dart';
import 'package:petit_bac/ui/ResultScreen.dart';
import 'package:petit_bac/widgets/exit_dialog.dart';
import 'package:petit_bac/widgets/game_header.dart';
import 'package:petit_bac/widgets/game_input_field.dart';
import 'package:petit_bac/widgets/loading_overlay.dart';

class GameScreen extends StatefulWidget {
  final String selectedLetter;

  const GameScreen({super.key, required this.selectedLetter});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _secondsRemaining = 102;
  Timer? _timer;
  bool _isLoading = false;

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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _finishGame();
      }
    });
  }

  Future<void> _finishGame() async {
    _timer?.cancel();
    setState(() => _isLoading = true);

    int correctAnswers = 0;
    int errors = 0;

    Map<String, String> finalUserAnswers = {};
    Map<String, bool> finalValidationResults = {};

    // Validation via WikipediaService
    final entries = _controllers.entries.toList();
    final validationResultsList = await Future.wait(
      entries.map((entry) => WikipediaService.isValidWord(
            entry.value.text,
            widget.selectedLetter,
            category: entry.key,
          )),
    );

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final category = entry.key;
      final text = entry.value.text.trim();
      final valid = validationResultsList[i];

      finalUserAnswers[category] = text;
      finalValidationResults[category] = valid;

      if (valid) {
        correctAnswers++;
      } else {
        errors++;
      }
    }

    if (!mounted) return;

    int finalScore = correctAnswers * 10;
    int totalPossible = _controllers.length * 10;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: finalScore,
          totalPossible: totalPossible,
          correctAnswers: correctAnswers,
          errors: errors,
          selectedLetter: widget.selectedLetter,
          userAnswers: finalUserAnswers,
          validationResults: finalValidationResults,
        ),
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
    _timer?.cancel();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const Color textGrey = Color(0xFF8A94A6);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: LoadingOverlay(
          isLoading: _isLoading,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        value: _formatTime(_secondsRemaining),
                        backgroundColor: isDark ? theme.cardColor : Colors.white,
                        textColor: isDark ? Colors.white : Colors.black,
                        hasBorder: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "C'est parti !",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: textGrey, fontSize: 15),
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
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _finishGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF4514F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 8,
                      shadowColor: const Color(0xFFF4514F).withOpacity(0.4),
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
      ),
    );
  }
}