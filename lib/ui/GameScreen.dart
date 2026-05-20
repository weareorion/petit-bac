import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petit_bac/ui/ResultScreen.dart';


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

  // --- LOGIQUE DE VALIDATION WIKIPEDIA ---

  Future<bool> _isValidWord(String word) async {
    String trimmedWord = word.trim();

    // Longeur du mot
    if (trimmedWord.length < 2) return false;

    // Premiere lettre
    if (!trimmedWord.toUpperCase().startsWith(
      widget.selectedLetter.toUpperCase(),
    )) {
      return false;
    }

    try {
      // list=search 
      final response = await http.get(
        Uri.parse(
          'https://fr.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=$trimmedWord&srlimit=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final searchResults = data['query']['search'] as List;

        if (searchResults.isEmpty) return false;

        String topResult = searchResults[0]['title'].toString().toLowerCase();
        String inputLower = trimmedWord.toLowerCase();

        
        if (topResult.contains(inputLower) || inputLower.contains(topResult)) {
          return true;
        }
      }
    } catch (e) {
      debugPrint("Erreur Wikipedia API: $e");
    }
    return false;
  }

  Future<void> _finishGame() async {
    _timer?.cancel();
    setState(() => _isLoading = true);

    int correctAnswers = 0;
    int errors = 0;

    // correction 
    Map<String, String> finalUserAnswers = {};
    Map<String, bool> finalValidationResults = {};

    // Check via Wikipedia en parallele
    final entries = _controllers.entries.toList();
    final validationResultsList = await Future.wait(
      entries.map((entry) => _isValidWord(entry.value.text)),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.blueAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Quitter la partie ?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D21),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Votre progression actuelle sera perdue.\nÊtes-vous sûr de vouloir abandonner ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8A94A6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continuer à jouer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.black.withOpacity(0.05)),
                    ),
                  ),
                  child: const Text(
                    'Quitter',
                    style: TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
    const Color backgroundGrey = Color(0xFFF8F9FB);
    const Color textGrey = Color(0xFF8A94A6);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog();
      },
      child: Scaffold(
        backgroundColor: backgroundGrey,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        _buildCircleButton(Icons.close, _showExitDialog),
                        const Spacer(),
                        _buildHeaderIndicator(
                          "LETTRE",
                          widget.selectedLetter,
                          Colors.blueAccent,
                          Colors.white,
                        ),
                        const SizedBox(width: 12),
                        _buildHeaderIndicator(
                          "TEMPS",
                          _formatTime(_secondsRemaining),
                          Colors.white,
                          Colors.black,
                          hasBorder: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "C'est parti !",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D21),
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
                        _buildInputGroup(
                          "PAYS",
                          "Entrez un pays...",
                          Icons.public,
                          _controllers["PAYS"]!,
                        ),
                        _buildInputGroup(
                          "FRUITS",
                          "Entrez un fruit...",
                          Icons.restaurant,
                          _controllers["FRUITS"]!,
                        ),
                        _buildInputGroup(
                          "VOITURES",
                          "Entrez une marque...",
                          Icons.directions_car,
                          _controllers["VOITURES"]!,
                        ),
                        _buildInputGroup(
                          "OBJET",
                          "Entrez un objet...",
                          Icons.category,
                          _controllers["OBJET"]!,
                        ),
                        _buildInputGroup(
                          "PRÉNOM FILLE",
                          "Entrez un prénom...",
                          Icons.face_3,
                          _controllers["PRÉNOM FILLE"]!,
                        ),
                        _buildInputGroup(
                          "PRÉNOM GARÇON",
                          "Entrez un prénom...",
                          Icons.face,
                          _controllers["PRÉNOM GARÇON"]!,
                        ),
                        _buildInputGroup(
                          "ANIMAL",
                          "Entrez un animal...",
                          Icons.pets,
                          _controllers["ANIMAL"]!,
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
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Correction en cours...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
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

  Widget _buildHeaderIndicator(
    String label,
    String value,
    Color bg,
    Color text, {
    bool hasBorder = false,
  }) {
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
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder
                ? Border.all(color: Colors.black.withOpacity(0.05))
                : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: text,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputGroup(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8A94A6),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.1)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(
                icon,
                color: Colors.black.withOpacity(0.1),
                size: 22,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}