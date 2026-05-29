import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/route_names.dart';
import 'package:petit_bac/ui/game_screen.dart';
import 'package:petit_bac/ui/home_screen.dart';
import 'package:petit_bac/ui/letter_generator.dart';
import 'package:petit_bac/ui/settings_screen.dart';

/// Route table for [MaterialApp.routes].
///
/// [RouteNames.scores] and [RouteNames.profile] are not registered here;
/// [NavBar] shows a placeholder snackbar for those tabs until screens exist.
final Map<String, WidgetBuilder> appRoutes = {
  RouteNames.home: (context) => const HomeScreen(),
  RouteNames.settings: (context) => const Settings(),
  RouteNames.letter: (context) => const LetterSpin(),
  RouteNames.play: (context) {
    final String letter =
        ModalRoute.of(context)!.settings.arguments as String;
    return GameScreen(selectedLetter: letter);
  },
};
