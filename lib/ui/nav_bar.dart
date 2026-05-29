import 'package:flutter/material.dart';
import 'package:petit_bac/core/constants/app_spacing.dart';
import 'package:petit_bac/core/constants/route_names.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    final List<String> routes = [
      RouteNames.home,
      RouteNames.scores,
      RouteNames.profile,
      RouteNames.settings,
    ];

    // Pour l'instant, seuls home et settings sont configurés dans les routes principales de l'app.
    // Pour éviter tout plantage si l'utilisateur clique sur profil ou scores :
    if (routes[index] == RouteNames.scores || routes[index] == RouteNames.profile) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cette section sera bientôt disponible !"),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.navMargin),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.navBarRadius),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.08), width: 1) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.navBarRadius),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: isDark ? Colors.white38 : Colors.grey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: "Scores"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profil"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: "Paramètres"),
          ],
        ),
      ),
    );
  }
}