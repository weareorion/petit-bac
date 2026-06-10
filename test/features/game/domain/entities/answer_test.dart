import 'package:flutter_test/flutter_test.dart';
import 'package:petit_bac/core/constants/app_constants.dart';
import 'package:petit_bac/features/game/domain/entities/answer.dart';

void main() {
  group('Answer.points', () {
    test('returns pointsPerValidAnswer when answer is valid', () {
      const answer = Answer(
        categoryId: 'pays',
        value: 'France',
        isValid: true,
      );

      expect(answer.points, AppConstants.pointsPerValidAnswer);
    });

    test('returns zero when answer is invalid', () {
      const answer = Answer(
        categoryId: 'pays',
        value: 'Allemagne',
        isValid: false,
      );

      expect(answer.points, 0);
    });
  });
}
