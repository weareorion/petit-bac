import 'package:petit_bac/core/constants/app_constants.dart';

/// A single category answer after validation.
class Answer {
  final String categoryId;
  final String value;
  final bool isValid;

  const Answer({
    required this.categoryId,
    required this.value,
    required this.isValid,
  });

  int get points => isValid ? AppConstants.pointsPerValidAnswer : 0;
}
