import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'health_record_screen.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  final ApiService _apiService = ApiService();
  String? patientId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    try {
      final userData = await _apiService.getUserData();
      setState(() {
        patientId = userData?['patient_id']?.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (patientId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kesehatan'),
        ),
        body: const Center(
          child: Text('Tidak dapat menemukan ID pasien'),
        ),
      );
    }

    return HealthRecordScreen(patientId: patientId!);
  }
}
