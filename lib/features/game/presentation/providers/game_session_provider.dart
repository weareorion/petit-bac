import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:petit_bac/core/constants/app_constants.dart';
import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/data/repositories/word_validation_repository.dart';
import 'package:petit_bac/features/game/domain/entities/round.dart';
import 'package:petit_bac/features/game/domain/usecases/validate_round.dart';

/// Manages an in-progress game round (timer, answers, validation).
///
/// Plain [ChangeNotifier] stub until Phase 3 Riverpod migration.
class GameSessionProvider extends ChangeNotifier {
  GameSessionProvider({
    required String letter,
    required ValidateRound validateRound,
    int initialSeconds = AppConstants.defaultTimerSeconds,
  })  : _letter = letter,
        _validateRound = validateRound,
        _secondsRemaining = initialSeconds;

  factory GameSessionProvider.create(String letter) {
    return GameSessionProvider(
      letter: letter,
      validateRound: ValidateRound(
        WordValidationRepository(WikipediaDataSource()),
      ),
    );
  }

  final ValidateRound _validateRound;
  final String _letter;

  int _secondsRemaining;
  bool _isLoading = false;
  Round? _completedRound;
  Timer? _timer;

  String get letter => _letter;
  int get secondsRemaining => _secondsRemaining;
  bool get isLoading => _isLoading;
  Round? get completedRound => _completedRound;

  void startTimer({required VoidCallback onTimeUp}) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
        onTimeUp();
      }
    });
  }

  void cancelTimer() => _timer?.cancel();

  Future<Round?> finishGame(Map<String, String> answersByCategory) async {
    if (_isLoading) return null;

    cancelTimer();
    _isLoading = true;
    notifyListeners();

    try {
      _completedRound = await _validateRound(
        letter: _letter,
        answersByCategory: answersByCategory,
      );
      return _completedRound;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}
