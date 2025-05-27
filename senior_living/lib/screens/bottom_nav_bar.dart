import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Ganti dengan path yang sesuai

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();

  Future<String?> _getPatientId() async {
    final userData = await _apiService.getUserData();
    return userData?['patient_id']?.toString();
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/schedule');
        break;
      case 2:
        Navigator.pushNamed(context, '/health'); // Simplified
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: "Jadwal"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Kesehatan"),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), label: "Pengaturan"),
      ],
    );
  }
}
