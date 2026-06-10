import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/utils/string_utils.dart';

class WordValidationRepository {
  WordValidationRepository(this._dataSource);

  final WikipediaDataSource _dataSource;

  /// Returns whether [word] is a valid answer for [letter] (Wikipedia-backed).
  Future<bool> isValid(String word, String letter) async {
    final cleanedWord = StringUtils.stripLeadingArticles(word);

    if (cleanedWord.length < 2) return false;

    final wordWithoutAccents = StringUtils.removeAccents(cleanedWord);
    if (!wordWithoutAccents.toUpperCase().startsWith(
      StringUtils.removeAccents(letter).toUpperCase(),
    )) {
      return false;
    }

    try {
      final topResult = await _dataSource.fetchTopSearchTitle(cleanedWord);
      if (topResult == null) return false;

      final normTop = StringUtils.normalizeForComparison(topResult);
      final normInput = StringUtils.normalizeForComparison(cleanedWord);

      return normTop.contains(normInput) || normInput.contains(normTop);
    } catch (_) {
      return false;
    }
  }
}
