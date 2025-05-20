// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/health_record.dart';

// Jika Anda menggunakan shared_preferences untuk token:
// import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String _baseUrl =
      'http://127.0.0.1:8000/api'; 

  Future<String?> _getToken() async {
    print("1|44T36weUcYOHm8XXHc4mdy9v0nxrfndC3HdxKA0i565e3287");
    return "1|44T36weUcYOHm8XXHc4mdy9v0nxrfndC3HdxKA0i565e3287"; 
  }

  Future<bool> simpanCatatanKesehatan({
    required String patientId,
    required DateTime tanggalPemeriksaan,
    String? tekananDarah,
    String? gulaDarah,
    String? kolesterol,
    String? asamUrat,
    String? catatan,
  }) async {
    final String? token = await _getToken();

    if (token == null) {
      print("Token tidak ditemukan. Pengguna belum login?");
      return false;
    }

    final String apiUrl = '$_baseUrl/checkups';

    Map<String, dynamic> dataPemeriksaan = {
      'patient_id':
          patientId, // patientId harus dikirim sebagai String jika API mengharapkannya
      'checkup_date': tanggalPemeriksaan
          .toIso8601String()
          .substring(0, 10), 
      if (tekananDarah != null && tekananDarah.isNotEmpty)
        'blood_pressure': tekananDarah,
      if (gulaDarah != null && gulaDarah.isNotEmpty)
        'blood_sugar_level': gulaDarah,
      if (kolesterol != null && kolesterol.isNotEmpty)
        'cholesterol_level': kolesterol,
      if (asamUrat != null && asamUrat.isNotEmpty) 'uric_acid_level': asamUrat,
      if (catatan != null && catatan.isNotEmpty) 'notes': catatan,
    };

    print("Mengirim data ke API: $dataPemeriksaan");
    print("Dengan token: $token");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization':
              'Bearer 2|kxAMymJGqDLvYxdOX0LbeFeMS3xVBK2dcUchC2AU46ce922b',
        },
        body: jsonEncode(dataPemeriksaan),
      );

      if (response.statusCode == 201) {
        // 201 Created
        print('Catatan kesehatan berhasil dikirim dan disimpan!');
        print('Response dari server: ${response.body}');
        // Tampilkan pesan sukses ke pengguna (misalnya dengan SnackBar)
        return true;
      } else {
        print(
            'Gagal menyimpan catatan kesehatan. Status: ${response.statusCode}');
        print('Error response dari server: ${response.body}');
        // Tampilkan pesan error ke pengguna
        // Anda bisa parse response.body jika berisi pesan error JSON dari Laravel
        return false;
      }
    } catch (e) {
      print('Terjadi kesalahan saat mengirim catatan kesehatan: $e');
      // Tampilkan pesan error umum ke pengguna
      return false;
    }
  }

  Future<List<HealthRecord>?> getCatatanKesehatan({String? patientId}) async {
    final String? token = await _getToken();
    if (token == null) {
      print("Token tidak ditemukan untuk getCatatanKesehatan.");
      return null;
    }

    String apiUrl = '$_baseUrl/checkups';
    if (patientId != null && patientId.isNotEmpty) {
      apiUrl += '?patient_id=$patientId';
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
          List<dynamic> listData = jsonResponse['data'];
          List<HealthRecord> records = listData.map((data) {
            return HealthRecord(
              id: data['id']?.toString() ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.parse(data['checkup_date']),
              bloodPressure: data['blood_pressure'],
              bloodSugar: data['blood_sugar_level'] != null
                  ? int.tryParse(data['blood_sugar_level'].toString())
                  : null,
              cholesterol: data['cholesterol_level'] != null
                  ? int.tryParse(data['cholesterol_level'].toString())
                  : null,
              uricAcid: data['uric_acid_level'] != null
                  ? double.tryParse(data['uric_acid_level'].toString())
                  : null,
              notes: data['notes'],
            );
          }).toList();

          return records;
        }
        print("Format response tidak sesuai atau data kosong");
        return [];
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
