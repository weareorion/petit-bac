import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/features/settings/domain/entities/app_settings.dart';
import 'package:petit_bac/features/settings/presentation/providers/settings_provider.dart';
import 'package:petit_bac/ui/nav_bar.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
    final controller = TextEditingController(text: settings.username);
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
                ref.read(settingsProvider.notifier).updateUsername(controller.text);
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

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppSettings settings) {
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
              _buildLanguageOption(context, ref, 'Français', settings),
              const Divider(height: 1),
              _buildLanguageOption(context, ref, 'English', settings),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String lang,
    AppSettings settings,
  ) {
    final isSelected = settings.language == lang;
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
        ref.read(settingsProvider.notifier).setLanguage(lang);
        Navigator.pop(context);
      },
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
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
                ref.read(settingsProvider.notifier).resetSettings();
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return settingsAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Erreur: $error')),
      ),
      data: (settings) {
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
                _buildProfileCard(context, ref, settings),
                const SizedBox(height: 30),
                _buildSectionTitle('PREFERENCE DE JEU'),
                _buildSettingsContainer(context, [
                  _buildSettingRow(
                    context: context,
                    icon: Icons.volume_up_outlined,
                    title: 'Sons',
                    trailing: Switch(
                      value: settings.soundsEnabled,
                      onChanged: (val) =>
                          ref.read(settingsProvider.notifier).toggleSounds(val),
                      activeColor: Colors.blueAccent,
                    ),
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  _buildSettingRow(
                    context: context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Mode sombre',
                    trailing: Switch(
                      value: settings.isDarkMode,
                      onChanged: (val) =>
                          ref.read(settingsProvider.notifier).toggleDarkMode(val),
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
                          settings.language,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                    onTap: () => _showLanguageDialog(context, ref, settings),
                  ),
                  Divider(height: 1, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  _buildSettingRow(
                    context: context,
                    icon: Icons.logout,
                    title: 'Réinitialiser l\'application',
                    textColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () => _showResetDialog(context, ref),
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

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) {
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
                  settings.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'Niveau ${settings.userLevel} • ${settings.userXp} XP',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEditProfileDialog(context, ref, settings),
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
