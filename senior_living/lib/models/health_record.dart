// lib/models/health_record.dart
import 'package:hive/hive.dart';

part 'health_record.g.dart'; // Nama file hasil generate

@HiveType(typeId: 1) // Pastikan typeId unik (ScheduleItem pakai 0)
class HealthRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date; // Simpan tanggal

  @HiveField(2)
  String? bloodPressure; // Format: "120/80"

  @HiveField(3)
  int? spo2; // Persentase

  @HiveField(4)
  int? bloodSugar; // mg/dL

  @HiveField(5)
  String? notes; // Catatan tambahan (opsional)

  HealthRecord({
    required this.id,
    required this.date,
    this.bloodPressure,
    this.spo2,
    this.bloodSugar,
    this.notes,
  });

  // Fungsi helper untuk mendapatkan status berdasarkan nilai
  String getBloodPressureStatus() {
    if (bloodPressure == null || bloodPressure!.isEmpty) return '-';
    try {
      final parts = bloodPressure!.split('/');
      if (parts.length != 2) return 'Error';
      final systole = int.parse(parts[0]);
      final diastole = int.parse(parts[1]);

      // Logika status (contoh sederhana, sesuaikan sesuai kebutuhan medis)
      if (systole < 120 && diastole < 80) return 'Optimal';
      if (systole >= 120 && systole <= 129 && diastole < 80) return 'Normal';
      if (systole >= 130 && systole <= 139 || diastole >= 80 && diastole <= 89) return 'Normal Tinggi';
      if (systole >= 140 || diastole >= 90) return 'Hipertensi'; // Waspada/Tinggi
      return 'Normal'; // Default
    } catch (e) {
      return 'Error';
    }
  }

  String getSpo2Status() {
    if (spo2 == null) return '-';
    if (spo2! >= 95) return 'Normal';
    if (spo2! >= 90) return 'Waspada';
    return 'Rendah'; // Butuh perhatian
  }

  String getBloodSugarStatus() {
    if (bloodSugar == null) return '-';
    // Logika status gula darah (contoh, sesuaikan jika puasa/tidak, dll.)
    if (bloodSugar! < 70) return 'Rendah';
    if (bloodSugar! >= 70 && bloodSugar! <= 130) return 'Normal'; // Gula darah sewaktu
    if (bloodSugar! > 130 && bloodSugar! <= 180) return 'Waspada';
    return 'Tinggi';
  }
}