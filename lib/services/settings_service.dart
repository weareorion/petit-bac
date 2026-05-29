import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/prefs_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Valeurs par defaut
  bool _isDarkMode = false;
  bool _soundsEnabled = true;
  bool _hapticsEnabled = true;
  String _language = 'Français';
  String _username = 'Joueur';
  int _userXp = 4250;
  int _userLevel = 12;

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get soundsEnabled => _soundsEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  String get language => _language;
  String get username => _username;
  int get userXp => _userXp;
  int get userLevel => _userLevel;

  // Initialisation
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();

    _isDarkMode = _prefs.getBool(PrefsKeys.isDarkMode) ?? false;
    _soundsEnabled = _prefs.getBool(PrefsKeys.soundsEnabled) ?? true;
    _hapticsEnabled = _prefs.getBool(PrefsKeys.hapticsEnabled) ?? true;
    _language = _prefs.getString(PrefsKeys.language) ?? 'Français';
    _username = _prefs.getString(PrefsKeys.username) ?? 'Joueur';
    _userXp = _prefs.getInt(PrefsKeys.userXp) ?? 4250;
    _userLevel = _prefs.getInt(PrefsKeys.userLevel) ?? 12;

    _isInitialized = true;
    notifyListeners();
  }

  // Setters avec persistance et notification
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool(PrefsKeys.isDarkMode, value);
    notifyListeners();
  }

  Future<void> toggleSounds(bool value) async {
    _soundsEnabled = value;
    await _prefs.setBool(PrefsKeys.soundsEnabled, value);
    notifyListeners();
  }

  Future<void> toggleHaptics(bool value) async {
    _hapticsEnabled = value;
    await _prefs.setBool(PrefsKeys.hapticsEnabled, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString(PrefsKeys.language, value);
    notifyListeners();
  }

  Future<void> updateUsername(String value) async {
    _username = value.trim().isEmpty ? 'Joueur' : value.trim();
    await _prefs.setString(PrefsKeys.username, _username);
    notifyListeners();
  }

  Future<void> resetSettings() async {
    _isDarkMode = false;
    _soundsEnabled = true;
    _hapticsEnabled = true;
    _language = 'Français';
    _username = 'Joueur';
    _userXp = 0;
    _userLevel = 1;

    await _prefs.setBool(PrefsKeys.isDarkMode, false);
    await _prefs.setBool(PrefsKeys.soundsEnabled, true);
    await _prefs.setBool(PrefsKeys.hapticsEnabled, true);
    await _prefs.setString(PrefsKeys.language, 'Français');
    await _prefs.setString(PrefsKeys.username, 'Joueur');
    await _prefs.setInt(PrefsKeys.userXp, 0);
    await _prefs.setInt(PrefsKeys.userLevel, 1);

    notifyListeners();
  }
}
