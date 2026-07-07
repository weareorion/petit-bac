import 'package:petit_bac/core/errors/app_exceptions.dart';
import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/utils/string_utils.dart';

class WordValidationRepository {
  WordValidationRepository(this._dataSource);

  final WikipediaDataSource _dataSource;

  /// Returns whether [word] is a valid answer for [letter] (Wikipedia-backed).
  Future<bool> isValid(
    String word,
    String letter, {
    String? category,
  }) async {
    final cleanedWord = StringUtils.stripLeadingArticles(word);

    if (cleanedWord.length < 2) return false;

    final wordWithoutAccents = StringUtils.removeAccents(cleanedWord);
    if (!wordWithoutAccents.toUpperCase().startsWith(
      StringUtils.removeAccents(letter).toUpperCase(),
    )) {
      return false;
    }

    try {
      final normInput = StringUtils.normalizeForComparison(cleanedWord);

      if (await _matchesWikipediaSearch(cleanedWord, normInput)) return true;

      if (category?.toUpperCase() == 'VOITURES') {
        return _matchesWikipediaSearch('$cleanedWord voiture', normInput);
      }

      return false;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Word validation failed: $e');
    }
  }

  Future<bool> _matchesWikipediaSearch(String query, String normInput) async {
    final titles = await _dataSource.fetchSearchTitles(query);
    if (titles.isEmpty) return false;

    for (final title in titles) {
      final normTop = StringUtils.normalizeForComparison(title);
      if (normTop.contains(normInput) || normInput.contains(normTop)) {
        return true;
      }
    }

    return false;
  }
}
