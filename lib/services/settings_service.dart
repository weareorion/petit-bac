import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends ChangeNotifier {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Valeurs par défaut
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

    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _soundsEnabled = _prefs.getBool('soundsEnabled') ?? true;
    _hapticsEnabled = _prefs.getBool('hapticsEnabled') ?? true;
    _language = _prefs.getString('language') ?? 'Français';
    _username = _prefs.getString('username') ?? 'Joueur';
    _userXp = _prefs.getInt('userXp') ?? 4250;
    _userLevel = _prefs.getInt('userLevel') ?? 12;

    _isInitialized = true;
    notifyListeners();
  }

  // Setters avec persistance et notification
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> toggleSounds(bool value) async {
    _soundsEnabled = value;
    await _prefs.setBool('soundsEnabled', value);
    notifyListeners();
  }

  Future<void> toggleHaptics(bool value) async {
    _hapticsEnabled = value;
    await _prefs.setBool('hapticsEnabled', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString('language', value);
    notifyListeners();
  }

  Future<void> updateUsername(String value) async {
    _username = value.trim().isEmpty ? 'Joueur' : value.trim();
    await _prefs.setString('username', _username);
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

    await _prefs.setBool('isDarkMode', false);
    await _prefs.setBool('soundsEnabled', true);
    await _prefs.setBool('hapticsEnabled', true);
    await _prefs.setString('language', 'Français');
    await _prefs.setString('username', 'Joueur');
    await _prefs.setInt('userXp', 0);
    await _prefs.setInt('userLevel', 1);

    notifyListeners();
  }
}
