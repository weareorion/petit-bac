import 'package:flutter/material.dart';
import 'package:petit_bac/services/settings_service.dart';
import 'package:petit_bac/ui/GameScreen.dart';
import 'package:petit_bac/ui/HomeScreen.dart';
import 'package:petit_bac/ui/LetterGenerator.dart';
import 'package:petit_bac/ui/Settings.dart';

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
          
          // Thème Clair
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.light,
              background: const Color(0xFFF8F9FE),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FE),
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Thème Sombre (Premium)
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
              background: const Color(0xFF0F172A),
              surface: const Color(0xFF1E293B),
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            cardColor: const Color(0xFF1E293B),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Mode Thème Actuel
          themeMode: settingsService.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          routes: {
            '/': (context) => const HomeScreen(),
            '/settings': (context) => const Settings(),
            '/letter': (context) => const LetterSpin(),
            '/play': (context) {
              final String letter = ModalRoute.of(context)!.settings.arguments as String;
              return GameScreen(selectedLetter: letter);
            },
          },
        );
      },
    );
  }
}