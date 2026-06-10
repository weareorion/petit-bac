import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petit_bac/app/router.dart';
import 'package:petit_bac/core/constants/app_theme.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/features/settings/presentation/providers/settings_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final themeMode = settingsAsync.maybeWhen(
      data: (settings) =>
          settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      orElse: () => ThemeMode.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petit Bac',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: RouteNames.home,
      routes: appRoutes,
      builder: (context, child) {
        return settingsAsync.when(
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Scaffold(
            body: Center(child: Text('Erreur: $error')),
          ),
          data: (_) => child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
