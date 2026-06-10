// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$validateRoundHash() => r'6cb172a10e0d905e60583910d65d9ab3a980d9ee';

/// See also [validateRound].
@ProviderFor(validateRound)
final validateRoundProvider = AutoDisposeProvider<ValidateRound>.internal(
  validateRound,
  name: r'validateRoundProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$validateRoundHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ValidateRoundRef = AutoDisposeProviderRef<ValidateRound>;
String _$gameSessionHash() => r'a1f54d7bc44560e4f838f0975074a9e1d692b025';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GameSession extends BuildlessAutoDisposeAsyncNotifier<Round?> {
  late final String letter;

  FutureOr<Round?> build(String letter);
}

/// Manages an in-progress game round: timer, validation, and completed [Round].
///
/// Copied from [GameSession].
@ProviderFor(GameSession)
const gameSessionProvider = GameSessionFamily();

/// Manages an in-progress game round: timer, validation, and completed [Round].
///
/// Copied from [GameSession].
class GameSessionFamily extends Family<AsyncValue<Round?>> {
  /// Manages an in-progress game round: timer, validation, and completed [Round].
  ///
  /// Copied from [GameSession].
  const GameSessionFamily();

  /// Manages an in-progress game round: timer, validation, and completed [Round].
  ///
  /// Copied from [GameSession].
  GameSessionProvider call(String letter) {
    return GameSessionProvider(letter);
  }

  @override
  GameSessionProvider getProviderOverride(
    covariant GameSessionProvider provider,
  ) {
    return call(provider.letter);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gameSessionProvider';
}

/// Manages an in-progress game round: timer, validation, and completed [Round].
///
/// Copied from [GameSession].
class GameSessionProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GameSession, Round?> {
  /// Manages an in-progress game round: timer, validation, and completed [Round].
  ///
  /// Copied from [GameSession].
  GameSessionProvider(String letter)
    : this._internal(
        () => GameSession()..letter = letter,
        from: gameSessionProvider,
        name: r'gameSessionProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameSessionHash,
        dependencies: GameSessionFamily._dependencies,
        allTransitiveDependencies: GameSessionFamily._allTransitiveDependencies,
        letter: letter,
      );

  GameSessionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.letter,
  }) : super.internal();

  final String letter;

  @override
  FutureOr<Round?> runNotifierBuild(covariant GameSession notifier) {
    return notifier.build(letter);
  }

  @override
  Override overrideWith(GameSession Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameSessionProvider._internal(
        () => create()..letter = letter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        letter: letter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GameSession, Round?> createElement() {
    return _GameSessionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameSessionProvider && other.letter == letter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, letter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GameSessionRef on AutoDisposeAsyncNotifierProviderRef<Round?> {
  /// The parameter `letter` of this provider.
  String get letter;
}

class _GameSessionProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GameSession, Round?>
    with GameSessionRef {
  _GameSessionProviderElement(super.provider);

  @override
  String get letter => (origin as GameSessionProvider).letter;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
