import 'package:flutter_test/flutter_test.dart';
import 'package:petit_bac/core/errors/app_exceptions.dart';
import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/data/repositories/word_validation_repository.dart';
import 'package:petit_bac/features/game/domain/usecases/validate_round.dart';

class _FakeWordValidationRepository extends WordValidationRepository {
  _FakeWordValidationRepository(this._validator)
      : super(WikipediaDataSource());

  final Future<bool> Function(String word, String letter) _validator;

  @override
  Future<bool> isValid(
    String word,
    String letter, {
    String? category,
  }) =>
      _validator(word, letter);
}

void main() {
  group('ValidateRound', () {
    test('throws ValidationException when letter is empty', () async {
      final useCase = ValidateRound(
        _FakeWordValidationRepository((_, __) async => true),
      );

      expect(
        () => useCase.call(letter: '   ', answersByCategory: {'pays': 'France'}),
        throwsA(isA<ValidationException>()),
      );
    });

    test('throws ValidationException when answers map is empty', () async {
      final useCase = ValidateRound(
        _FakeWordValidationRepository((_, __) async => true),
      );

      expect(
        () => useCase.call(letter: 'F', answersByCategory: {}),
        throwsA(isA<ValidationException>()),
      );
    });

    test('builds a scored round from repository validation results', () async {
      final useCase = ValidateRound(
        _FakeWordValidationRepository((word, letter) async {
          if (word == 'France' && letter == 'F') return true;
          if (word == 'Paris' && letter == 'F') return false;
          return false;
        }),
      );

      final round = await useCase.call(
        letter: 'F',
        answersByCategory: {
          'pays': ' France ',
          'ville': 'Paris',
        },
      );

      expect(round.letter, 'F');
      expect(round.answers, hasLength(2));
      expect(round.answers[0].categoryId, 'pays');
      expect(round.answers[0].value, 'France');
      expect(round.answers[0].isValid, isTrue);
      expect(round.answers[1].categoryId, 'ville');
      expect(round.answers[1].value, 'Paris');
      expect(round.answers[1].isValid, isFalse);
      expect(round.totalScore, 10);
      expect(round.correctCount, 1);
      expect(round.errorCount, 1);
    });

    test('validates each category answer independently', () async {
      final validatedWords = <String>[];

      final useCase = ValidateRound(
        _FakeWordValidationRepository((word, letter) async {
          validatedWords.add('$word:$letter');
          return word.startsWith(letter);
        }),
      );

      await useCase.call(
        letter: 'F',
        answersByCategory: {
          'pays': 'France',
          'ville': 'Berlin',
        },
      );

      expect(validatedWords, containsAll(['France:F', 'Berlin:F']));
    });
  });
}
