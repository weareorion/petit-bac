import 'dart:async';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String selectedLetter;

  const GameScreen({super.key, required this.selectedLetter});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _secondsRemaining = 102; 
  Timer? _timer;

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
        Navigator.pop(context);
      }
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
                // Titre
                const Text(
                  'Quitter la partie ?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1D21),
                  ),
                ),
                const SizedBox(height: 12),
                // Message
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
                // Bouton Continuer
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
                // Bouton Quitter
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundGrey = Color(0xFFF8F9FB);
    const Color textGrey = Color(0xFF8A94A6);

    return PopScope(
      canPop: false, // 
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog(); 
      },
      child: Scaffold(
        backgroundColor: backgroundGrey,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header Lettre et Temps
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildCircleButton(Icons.close, _showExitDialog),
                    const Spacer(),
                    _buildHeaderIndicator("LETTRE", widget.selectedLetter, Colors.blueAccent, Colors.white),
                    const SizedBox(width: 12),
                    _buildHeaderIndicator("TEMPS", _formatTime(_secondsRemaining), Colors.white, Colors.black, hasBorder: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Titres
              const Text(
                "C'est parti !",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1D21)),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: textGrey, fontSize: 15),
                  children: [
                    const TextSpan(text: "Trouvez des mots commençant par la lettre "),
                    TextSpan(
                      text: widget.selectedLetter,
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Liste des categories
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildInputGroup("PAYS", "...", Icons.public),
                    _buildInputGroup("FRUITS", "...", Icons.restaurant),
                    _buildInputGroup("VOITURES", "...", Icons.directions_car),
                    _buildInputGroup("OBJET", "...", Icons.category),
                    _buildInputGroup("PRÉNOM FILLE", "...", Icons.face_3),
                    _buildInputGroup("PRÉNOM GARÇON", "...", Icons.face),
                    _buildInputGroup("ANIMAL", "...", Icons.pets),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Bouton STOP
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4514F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 8,
                    shadowColor: const Color(0xFFF4514F).withOpacity(0.4),
                  ),
                  icon: const Icon(Icons.front_hand, size: 24),
                  label: const Text("STOP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: IconButton(icon: Icon(icon, color: const Color(0xFF8A94A6), size: 20), onPressed: onTap),
    );
  }

  Widget _buildHeaderIndicator(String label, String value, Color bg, Color text, {bool hasBorder = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder ? Border.all(color: Colors.black.withOpacity(0.05)) : null,
          ),
          child: Text(value, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ],
    );
  }

  Widget _buildInputGroup(String label, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF8A94A6), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.1)),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: Icon(icon, color: Colors.black.withOpacity(0.1), size: 22),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}