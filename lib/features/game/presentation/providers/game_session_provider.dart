import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petit_bac/core/constants/app_constants.dart';
import 'package:petit_bac/data/datasources/wikipedia_datasource.dart';
import 'package:petit_bac/data/repositories/word_validation_repository.dart';
import 'package:petit_bac/features/game/domain/entities/round.dart';
import 'package:petit_bac/features/game/domain/usecases/validate_round.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_session_provider.g.dart';

@riverpod
ValidateRound validateRound(Ref ref) {
  return ValidateRound(WordValidationRepository(WikipediaDataSource()));
}

/// Manages an in-progress game round: timer, validation, and completed [Round].
@riverpod
class GameSession extends _$GameSession {
  Timer? _timer;
  int _secondsRemaining = AppConstants.defaultTimerSeconds;

  @override
  FutureOr<Round?> build(String letter) {
    _secondsRemaining = AppConstants.defaultTimerSeconds;
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  ValidateRound get _validateRound => ref.read(validateRoundProvider);

  int get secondsRemaining => _secondsRemaining;

  void startTimer({required void Function() onTimeUp}) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _notifyInProgress();
      } else {
        _timer?.cancel();
        onTimeUp();
      }
    });
  }

  void cancelTimer() => _timer?.cancel();

  Future<Round?> finishGame(Map<String, String> answersByCategory) async {
    if (state.isLoading) return null;

    cancelTimer();
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _validateRound(
        letter: letter,
        answersByCategory: answersByCategory,
      ),
    );
    return state.value;
  }

  void _notifyInProgress() {
    if (!state.isLoading) {
      state = const AsyncData(null);
    }
  }
}
