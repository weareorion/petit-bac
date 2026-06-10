/// User preferences and profile data persisted via SharedPreferences.
class AppSettings {
  const AppSettings({
    required this.isDarkMode,
    required this.soundsEnabled,
    required this.hapticsEnabled,
    required this.language,
    required this.username,
    required this.userXp,
    required this.userLevel,
  });

  static const defaults = AppSettings(
    isDarkMode: false,
    soundsEnabled: true,
    hapticsEnabled: true,
    language: 'Français',
    username: 'Joueur',
    userXp: 4250,
    userLevel: 12,
  );

  static const reset = AppSettings(
    isDarkMode: false,
    soundsEnabled: true,
    hapticsEnabled: true,
    language: 'Français',
    username: 'Joueur',
    userXp: 0,
    userLevel: 1,
  );

  final bool isDarkMode;
  final bool soundsEnabled;
  final bool hapticsEnabled;
  final String language;
  final String username;
  final int userXp;
  final int userLevel;

  AppSettings copyWith({
    bool? isDarkMode,
    bool? soundsEnabled,
    bool? hapticsEnabled,
    String? language,
    String? username,
    int? userXp,
    int? userLevel,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      language: language ?? this.language,
      username: username ?? this.username,
      userXp: userXp ?? this.userXp,
      userLevel: userLevel ?? this.userLevel,
    );
  }
}
