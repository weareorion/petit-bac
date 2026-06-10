import 'package:petit_bac/core/constants/app_constants.dart';
import 'package:petit_bac/features/game/domain/entities/answer.dart';

/// A completed round: letter plus validated answers and derived scores.
class Round {
  final String letter;
  final List<Answer> answers;

  const Round({
    required this.letter,
    required this.answers,
  });

  int get totalScore =>
      answers.fold(0, (sum, answer) => sum + answer.points);

  int get correctCount => answers.where((a) => a.isValid).length;

  int get errorCount => answers.where((a) => !a.isValid).length;

  int get totalPossible =>
      answers.length * AppConstants.pointsPerValidAnswer;
}
