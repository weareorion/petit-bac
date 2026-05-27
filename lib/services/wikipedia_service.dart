import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petit_bac/utils/string_utils.dart';

class WikipediaService {
  /// Verification Premiere Lettre et Mot
  static Future<bool> isValidWord(String word, String selectedLetter) async {
    String cleanedWord = StringUtils.stripLeadingArticles(word);

    // Longueur minimale
    if (cleanedWord.length < 2) return false;

    // Premiere lettre insensible aux accents
    String wordWithoutAccents = StringUtils.removeAccents(cleanedWord);
    if (!wordWithoutAccents.toUpperCase().startsWith(
      StringUtils.removeAccents(selectedLetter).toUpperCase(),
    )) {
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://fr.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=$cleanedWord&srlimit=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final searchResults = data['query']['search'] as List;

        if (searchResults.isEmpty) return false;

        String topResult = searchResults[0]['title'].toString();

        // Normalisation pour la comparaison
        String normTop = StringUtils.normalizeForComparison(topResult);
        String normInput = StringUtils.normalizeForComparison(cleanedWord);

        if (normTop.contains(normInput) || normInput.contains(normTop)) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('Erreur API: $e');
    }
    return false;
  }
}
