import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/services/settings_service.dart';
import 'package:petit_bac/ui/nav_bar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  // Dialogue pour modifier le pseudo
  void _showEditProfileDialog(BuildContext context, SettingsService settingsService) {
    final controller = TextEditingController(text: settingsService.username);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Modifier le profil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: "Entrez votre pseudo",
              hintStyle: TextStyle(color: theme.hintColor),
              filled: true,
              fillColor: theme.scaffoldBackgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                settingsService.updateUsername(controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Dialogue de sélection de langue
  void _showLanguageDialog(BuildContext context, SettingsService settingsService) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Choisir la langue',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'Français', settingsService),
              const Divider(height: 1),
              _buildLanguageOption(context, 'English', settingsService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String lang, SettingsService settingsService) {
    final isSelected = settingsService.language == lang;
    return ListTile(
      title: Text(
        lang,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blueAccent : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blueAccent) : null,
      onTap: () {
        settingsService.setLanguage(lang);
        Navigator.pop(context);
      },
    );
  }

  // Confirmation de réinitialisation
  void _showResetDialog(BuildContext context, SettingsService settingsService) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Réinitialiser les réglages',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Voulez-vous vraiment réinitialiser toutes vos préférences et vos scores ? Cette action est irréversible.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                settingsService.resetSettings();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Réglages réinitialisés avec succès !"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Réinitialiser', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, _) {
        final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
              onPressed: () => Navigator.popAndPushNamed(context, RouteNames.home),
            ),
            title: Text(
              'Réglages',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildProfileCard(context, settingsService),
                const SizedBox(height: 30),
                _buildSectionTitle('PREFERENCE DE JEU'),
                _buildSettingsContainer(context, [
                  _buildSettingRow(
                    context: context,
                    icon: Icons.volume_up_outlined,
                    title: 'Sons',
                    trailing: Switch(
                      value: settingsService.soundsEnabled,
                      onChanged: (val) => settingsService.toggleSounds(val),
                      activeColor: Colors.blueAccent,
                    ),
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  _buildSettingRow(
                    context: context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Mode sombre',
                    trailing: Switch(
                      value: settingsService.isDarkMode,
                      onChanged: (val) => settingsService.toggleDarkMode(val),
                      activeColor: Colors.blueAccent,
                    ),
                  ),
                ]),
                const SizedBox(height: 30),
                _buildSectionTitle('GENERAL'),
                _buildSettingsContainer(context, [
                  _buildSettingRow(
                    context: context,
                    icon: Icons.language,
                    title: 'Langue',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settingsService.language,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: () => _showLanguageDialog(context, settingsService),
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  _buildSettingRow(
                    context: context,
                    icon: Icons.logout,
                    title: 'Réinitialiser l\'application',
                    textColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () => _showResetDialog(context, settingsService),
                  ),
                ]),
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Version 2.4.0',
                        style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '© 2026 Petit Bac Word Game',
                        style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: const NavBar(currentIndex: 3),
        );
      },
    );
  }

  // --- Composants internes ---

  Widget _buildProfileCard(BuildContext context, SettingsService settingsService) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.blueAccent,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  settingsService.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'Niveau ${settingsService.userLevel} • ${settingsService.userXp} XP',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEditProfileDialog(context, settingsService),
            child: const Text(
              'Modifier',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSettingsContainer(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(25),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    Color iconColor = Colors.blueAccent,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final resolvedTextColor = textColor ?? theme.textTheme.bodyLarge?.color ?? Colors.black;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: resolvedTextColor, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
    );
  }
}

