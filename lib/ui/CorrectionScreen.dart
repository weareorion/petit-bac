import 'package:flutter/material.dart';

class CorrectionScreen extends StatelessWidget {
  final String selectedLetter;
  final Map<String, String> userAnswers;
  final Map<String, bool> validationResults; 

  const CorrectionScreen({
    super.key,
    required this.selectedLetter,
    required this.userAnswers,
    required this.validationResults,
  });

  @override
  Widget build(BuildContext context) {
    const Color backgroundGrey = Color(0xFFF8F9FB);
    const Color successGreen = Color(0xFF4CAF50);
    const Color errorRed = Color(0xFFF44336);
    const Color primaryPurple = Color(0xFF7C4DFF);

    int totalScore = validationResults.values.where((v) => v).length * 10;

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Correction',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Score
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat("Lettre choisie", selectedLetter, primaryPurple),
                _buildHeaderStat("Score final", "$totalScore/70", primaryPurple),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSectionTitle("Bonnes Réponses", Icons.check_circle_outline, successGreen, "+${totalScore} pts"),
                ...userAnswers.entries.where((e) => validationResults[e.key] == true).map(
                      (e) => _buildCorrectionCard(e.key, e.value, true),
                    ),
                
                const SizedBox(height: 24),
                
                _buildSectionTitle("Mauvaises Réponses", Icons.highlight_off, errorRed, "0 pts"),
                ...userAnswers.entries.where((e) => validationResults[e.key] == false).map(
                      (e) => _buildCorrectionCard(e.key, e.value, false),
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
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/letter', (route) => false),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          icon: const Icon(Icons.refresh, color: Colors.white),
          label: const Text("REJOUER", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 14)),
        const SizedBox(height: 8),
        Text(value, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(points, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCorrectionCard(String category, String answer, bool isValid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isValid ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  answer.isEmpty ? "Pas de réponse" : answer,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: answer.isEmpty ? Colors.grey : (isValid ? Colors.black : Colors.red),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isValid ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isValid ? "+10" : "0",
              style: TextStyle(color: isValid ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}