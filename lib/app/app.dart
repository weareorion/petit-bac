import 'package:flutter/material.dart';
import 'package:petit_bac/app/router.dart';
import 'package:petit_bac/services/settings_service.dart';

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
          theme: settingsService.lightTheme,
          darkTheme: settingsService.darkTheme,
          themeMode:
              settingsService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routes: appRoutes,
        );
      },
    );
  }
}
