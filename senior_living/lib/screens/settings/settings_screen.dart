import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              // Navigate to profile settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/opening');
            },
          ),
        ],
      ),
    );
  }
}
