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

  @HiveField(6)
  int? cholesterol;

  @HiveField(7)
  double? uricAcid;

  HealthRecord({
    required this.id,
    required this.date,
    this.bloodPressure,
    this.spo2,
    this.bloodSugar,
    this.notes,
    this.cholesterol,
    this.uricAcid,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id']?.toString() ?? '',
      date: DateTime.parse(json['checkup_date']),
      bloodPressure: json['blood_pressure'],
      spo2: json['oxygen_saturation'] != null
          ? int.tryParse(json['oxygen_saturation'].toString())
          : null,
      bloodSugar: json['blood_sugar'] != null
          ? int.tryParse(json['blood_sugar'].toString())
          : null,
      cholesterol: json['cholesterol'] != null
          ? int.tryParse(json['cholesterol'].toString())
          : null,
      uricAcid: json['uric_acid'] != null
          ? double.tryParse(json['uric_acid'].toString())
          : null,
      notes: json['notes'],
    );
  }

  // Fungsi helper untuk mendapatkan status berdasarkan nilai
  String getBloodPressureStatus() {
    if (bloodPressure == null || bloodPressure!.isEmpty) return '-';
    try {
      final parts = bloodPressure!.split('/');
      if (parts.length != 2) return 'Error';

      final systole = int.parse(parts[0]); // TDS
      final diastole = int.parse(parts[1]); // TDD

      // Kategori sesuai dengan pedoman standar medis
      if (systole < 90 || diastole < 60) return 'Rendah';
      if (systole < 120 && diastole < 80) return 'Normal';
      if ((systole >= 121 && systole <= 139) ||
          (diastole >= 81 && diastole <= 89)) return 'Pra-hipertensi';
      if ((systole >= 140 && systole <= 159) ||
          (diastole >= 90 && diastole <= 99)) return 'Hipertensi tingkat 1';
      if (systole >= 160 || diastole >= 100) return 'Hipertensi tingkat 2';
      if (systole > 140 && diastole < 90)
        return 'Hipertensi Sistolik Terisolasi';

      return 'Normal'; // Default jika tidak masuk kategori manapun
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
    if (bloodSugar! >= 70 && bloodSugar! <= 130)
      return 'Normal'; // Gula darah sewaktu
    if (bloodSugar! > 130 && bloodSugar! <= 180) return 'Waspada';
    return 'Tinggi';
  }

  String getCholesterolStatus() {
    if (cholesterol == null) return '-';
    if (cholesterol! < 200) return 'Normal';
    if (cholesterol! < 240) return 'Batas Tinggi';
    return 'Tinggi';
  }

  String getUricAcidStatus() {
    if (uricAcid == null) return '-';
    // Nilai normal berbeda untuk pria dan wanita
    // Ini menggunakan nilai umum, sesuaikan dengan kebutuhan
    if (uricAcid! < 7.0) return 'Normal';
    return 'Tinggi';
  }
}
