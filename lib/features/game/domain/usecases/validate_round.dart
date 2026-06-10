import 'package:petit_bac/data/repositories/word_validation_repository.dart';
import 'package:petit_bac/features/game/domain/entities/answer.dart';
import 'package:petit_bac/features/game/domain/entities/round.dart';

/// Validates all category answers for a letter and returns a scored [Round].
class ValidateRound {
  ValidateRound(this._repository);

  final WordValidationRepository _repository;

  Future<Round> call({
    required String letter,
    required Map<String, String> answersByCategory,
  }) async {
    final entries = answersByCategory.entries.toList();
    final validationResults = await Future.wait(
      entries.map(
        (entry) => _repository.isValid(entry.value.trim(), letter),
      ),
    );

    final answers = <Answer>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      answers.add(
        Answer(
          categoryId: entry.key,
          value: entry.value.trim(),
          isValid: validationResults[i],
        ),
      );
    }

    return Round(letter: letter, answers: answers);
  }
}
