import 'package:flutter/material.dart';
import './NavBar.dart';
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Réglages',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildProfileCard(),
            const SizedBox(height: 30),
            _buildSectionTitle('PREFERENCE DE JEU'),
            _buildSettingsContainer([
              _buildSettingRow(
                icon: Icons.volume_up_outlined,
                title: 'Sons',
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.blueAccent,
                ),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.vibration,
                title: 'Haptique',
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Colors.blueAccent,
                ),
              ),
            ]),
            const SizedBox(height: 30),
            _buildSectionTitle('GENERAL'),
            _buildSettingsContainer([
              _buildSettingRow(
                icon: Icons.language,
                title: 'Langue',
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Français', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              const Divider(height: 1),
              _buildSettingRow(
                icon: Icons.logout,
                title: 'Déconnexion',
                textColor: Colors.redAccent,
                iconColor: Colors.redAccent,
                onTap: () {
                  // Logique de déconnexion
                },
              ),
            ]),
            const SizedBox(height: 40),
            const Center(
              child: Column(
                children: [
                  Text('Version 2.4.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('© 2024 Petit Bac Word Game', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Utilisation de ton composant centralisé
      bottomNavigationBar: const NavBar(currentIndex: 3), 
    );
  }

  // --- Composants internes gardés ---

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.person_outline, color: Colors.blueAccent, size: 30),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Utilisateur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Niveau 12 • 4,250 XP', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Modifier', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
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
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color textColor = Colors.black,
    Color iconColor = Colors.blueAccent,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
    );
  }
}