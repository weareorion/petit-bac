import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/data/repositories/word_validation_repository.dart';

class WikipediaService {
  static final WordValidationRepository _repository =
      WordValidationRepository(WikipediaDataSource());

  /// Verification Premiere Lettre et Mot
  static Future<bool> isValidWord(
    String word,
    String selectedLetter, {
    String? category,
  }) async {
    try {
      return await _repository.isValid(
        word,
        selectedLetter,
        category: category,
      );
    } catch (_) {
      return false;
    }
  }
}
