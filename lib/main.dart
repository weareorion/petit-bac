import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/services/settings_service.dart';
import 'package:petit_bac/ui/game_screen.dart';
import 'package:petit_bac/ui/home_screen.dart';
import 'package:petit_bac/ui/letter_generator.dart';
import 'package:petit_bac/ui/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialisation du service de préférences locales
  final settingsService = SettingsService();
  await settingsService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = SettingsService();

    return ListenableBuilder(
      listenable: settingsService,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Petit Bac',
          
          // Themes de l'application
          theme: settingsService.lightTheme,
          darkTheme: settingsService.darkTheme,

          // Mode Theme Actuel
          themeMode: settingsService.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          routes: {
            RouteNames.home: (context) => const HomeScreen(),
            RouteNames.settings: (context) => const Settings(),
            RouteNames.letter: (context) => const LetterSpin(),
            RouteNames.play: (context) {
              final String letter = ModalRoute.of(context)!.settings.arguments as String;
              return GameScreen(selectedLetter: letter);
            },
          },
        );
      },
    );
  }
}