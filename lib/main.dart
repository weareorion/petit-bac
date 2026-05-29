import 'package:flutter/material.dart';
import 'package:petit_bac/app/app.dart';
import 'package:petit_bac/services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  await settingsService.init();

  runApp(const MyApp());
}
