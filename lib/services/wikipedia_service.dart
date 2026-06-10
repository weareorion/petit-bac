import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/utils/string_utils.dart';

class WikipediaService {
  static final WikipediaDataSource _dataSource = WikipediaDataSource();

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
      final topResult = await _dataSource.fetchTopSearchTitle(cleanedWord);
      if (topResult == null) return false;

      // Normalisation pour la comparaison
      String normTop = StringUtils.normalizeForComparison(topResult);
      String normInput = StringUtils.normalizeForComparison(cleanedWord);

      return normTop.contains(normInput) || normInput.contains(normTop);
    } catch (_) {
      return false;
    }
  }
}
