import 'package:petit_bac/core/constants/prefs_keys.dart';
import 'package:petit_bac/features/settings/domain/entities/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    return _loadFromPrefs(prefs);
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.isDarkMode, value);
    _updateState((settings) => settings.copyWith(isDarkMode: value));
  }

  Future<void> toggleSounds(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.soundsEnabled, value);
    _updateState((settings) => settings.copyWith(soundsEnabled: value));
  }

  Future<void> toggleHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PrefsKeys.hapticsEnabled, value);
    _updateState((settings) => settings.copyWith(hapticsEnabled: value));
  }

  Future<void> setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsKeys.language, value);
    _updateState((settings) => settings.copyWith(language: value));
  }

  Future<void> updateUsername(String value) async {
    final username = value.trim().isEmpty ? 'Joueur' : value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PrefsKeys.username, username);
    _updateState((settings) => settings.copyWith(username: username));
  }

  Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    const reset = AppSettings.reset;

    await prefs.setBool(PrefsKeys.isDarkMode, reset.isDarkMode);
    await prefs.setBool(PrefsKeys.soundsEnabled, reset.soundsEnabled);
    await prefs.setBool(PrefsKeys.hapticsEnabled, reset.hapticsEnabled);
    await prefs.setString(PrefsKeys.language, reset.language);
    await prefs.setString(PrefsKeys.username, reset.username);
    await prefs.setInt(PrefsKeys.userXp, reset.userXp);
    await prefs.setInt(PrefsKeys.userLevel, reset.userLevel);

    state = const AsyncData(reset);
  }

  void _updateState(AppSettings Function(AppSettings settings) update) {
    final current = state.requireValue;
    state = AsyncData(update(current));
  }

  AppSettings _loadFromPrefs(SharedPreferences prefs) {
    const defaults = AppSettings.defaults;

    return AppSettings(
      isDarkMode: prefs.getBool(PrefsKeys.isDarkMode) ?? defaults.isDarkMode,
      soundsEnabled:
          prefs.getBool(PrefsKeys.soundsEnabled) ?? defaults.soundsEnabled,
      hapticsEnabled:
          prefs.getBool(PrefsKeys.hapticsEnabled) ?? defaults.hapticsEnabled,
      language: prefs.getString(PrefsKeys.language) ?? defaults.language,
      username: prefs.getString(PrefsKeys.username) ?? defaults.username,
      userXp: prefs.getInt(PrefsKeys.userXp) ?? defaults.userXp,
      userLevel: prefs.getInt(PrefsKeys.userLevel) ?? defaults.userLevel,
    );
  }
}
