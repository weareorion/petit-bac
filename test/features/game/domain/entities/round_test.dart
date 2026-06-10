import 'package:flutter_test/flutter_test.dart';
import 'package:petit_bac/core/constants/app_constants.dart';
import 'package:petit_bac/features/game/domain/entities/answer.dart';
import 'package:petit_bac/features/game/domain/entities/round.dart';

void main() {
  group('Round.totalScore', () {
    test('returns zero when there are no answers', () {
      const round = Round(letter: 'F', answers: []);

      expect(round.totalScore, 0);
    });

    test('sums points from all valid answers', () {
      const round = Round(
        letter: 'F',
        answers: [
          Answer(categoryId: 'pays', value: 'France', isValid: true),
          Answer(categoryId: 'ville', value: 'Fès', isValid: true),
          Answer(categoryId: 'animal', value: 'Chat', isValid: false),
        ],
      );

      expect(round.totalScore, AppConstants.pointsPerValidAnswer * 2);
    });

    test('returns zero when every answer is invalid', () {
      const round = Round(
        letter: 'F',
        answers: [
          Answer(categoryId: 'pays', value: 'Allemagne', isValid: false),
          Answer(categoryId: 'ville', value: 'Paris', isValid: false),
        ],
      );

      expect(round.totalScore, 0);
    });
  });
}
