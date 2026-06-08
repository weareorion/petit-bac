import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:petit_bac/utils/string_utils.dart';

class WikipediaService {
  /// Verification Premiere Lettre et Mot
  static Future<bool> isValidWord(String word, String selectedLetter, {String? category}) async {
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

    String normInput = StringUtils.normalizeForComparison(cleanedWord);

    // Helper method to check Wikipedia results
    Future<bool> checkWikipediaQuery(String query) async {
      try {
        final response = await http.get(
          Uri.parse(
            'https://fr.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=${Uri.encodeComponent(query)}&srlimit=5',
          ),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final searchResults = data['query']['search'] as List;

          for (var result in searchResults) {
            String title = result['title'].toString();
            String normTop = StringUtils.normalizeForComparison(title);

            if (normTop.contains(normInput) || normInput.contains(normTop)) {
              return true;
            }
          }
        }
      } catch (e) {
        debugPrint('Erreur API: $e');
      }
      return false;
    }

    // 1. First attempt: search for the word directly (checking top 5 results)
    if (await checkWikipediaQuery(cleanedWord)) {
      return true;
    }

    // 2. Second attempt (fallback): specific to VOITURES, search with 'voiture' appended
    if (category?.toUpperCase() == 'VOITURES') {
      if (await checkWikipediaQuery('$cleanedWord voiture')) {
        return true;
      }
    }

    return false;
  }
}
