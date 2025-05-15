import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Kontrol')),
      body: const Center(child: Text('Halaman Riwayat Kontrol')),
    );
  }
}
