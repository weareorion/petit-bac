import 'package:flutter/material.dart';
import 'package:petit_bac/ui/GameScreen.dart';
import 'package:petit_bac/ui/HomeScreen.dart';
import 'package:petit_bac/ui/LetterGenerator.dart';
import 'package:petit_bac/ui/Settings.dart';

void main() {
  runApp(const MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petit Bac',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/' : (context) => const HomeScreen(),
        '/settings' : (context) => const Settings(),
        '/letter' : (context) => const LetterSpin(),
        '/play' : (context) {
          final String letter = ModalRoute.of(context)!.settings.arguments as String;
          return GameScreen(selectedLetter: letter);
        },
        
      },
    );
  }
}



 
  
