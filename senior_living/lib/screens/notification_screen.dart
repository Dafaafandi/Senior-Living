import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Pengingat Jadwal'),
            subtitle: Text('Anda memiliki jadwal pemeriksaan hari ini'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.health_and_safety),
            title: Text('Catatan Kesehatan'),
            subtitle: Text('Waktunya mencatat tekanan darah'),
          ),
        ],
      ),
    );
  }
}
