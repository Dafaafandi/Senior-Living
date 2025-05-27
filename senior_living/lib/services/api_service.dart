// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_record.dart'; // Pastikan path ini benar
import '../models/user_model.dart'; // Anda mungkin perlu model User

class ApiService {
  // Gunakan 10.0.2.2 untuk emulator Android agar bisa akses localhost mesin
  static const String _baseUrl = 'http://127.0.0.1:8000/api';
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data'; // Untuk menyimpan data user

  // Fungsi untuk menyimpan token dan data user
  Future<void> _saveAuthData(
      String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userDataKey,
        jsonEncode(userData)); // Simpan data user sebagai JSON String
  }

  // Fungsi untuk mengambil token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Fungsi untuk mengambil data user
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  // Fungsi untuk menghapus token dan data user (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userDataKey);
    // Anda juga bisa memanggil endpoint logout API di sini jika ada
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final String apiUrl = '$_baseUrl/login';
    const String deviceName = "flutter_app_device";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      );

      print("DEBUG Login API Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('token') &&
            responseData.containsKey('user')) {
          await _saveAuthData(responseData['token'], responseData['user']);
          final User user =
              User.fromJson(responseData['user'] as Map<String, dynamic>);
          return {
            'success': true,
            'user': user.toJson(), // Convert back to map for consistency
            'message': responseData['message'] ?? 'Login berhasil'
          };
        }
        return {'success': false, 'message': 'Format respons tidak valid'};
      }

      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Login gagal'
      };
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final String apiUrl = '$_baseUrl/register';
    const String deviceName =
        "flutter_app_device"; // Atau dapatkan dari device info

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'device_name': deviceName,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        // Otomatis login setelah registrasi jika API mengembalikan token
        if (responseData.containsKey('token') &&
            responseData.containsKey('user')) {
          await _saveAuthData(responseData['token'], responseData['user']);
          return {
            'success': true,
            'user': responseData['user'],
            'message': responseData['message'] ??
                'Registrasi berhasil dan otomatis login.'
          };
        }
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registrasi berhasil'
        };
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            'Registrasi gagal. Status: ${response.statusCode}';
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        } else if (errorData.containsKey('errors')) {
          // Laravel validation errors
          final errors = errorData['errors'] as Map<String, dynamic>;
          errorMessage =
              errors.entries.map((e) => '${e.key}: ${e.value[0]}').join('\n');
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Terjadi kesalahan saat registrasi: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> simpanCatatanKesehatan({
    required String patientId,
    required DateTime tanggalPemeriksaan,
    String? tekananDarah,
    String? spo2,
    String? gulaDarah,
    String? kolesterol,
    String? asamUrat,
    String? catatan,
  }) async {
    final String? token = await getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan, silakan login ulang.'
      };
    }

    Map<String, dynamic> dataPemeriksaan = {
      'patient_id': patientId,
      'checkup_date': tanggalPemeriksaan.toIso8601String().substring(0, 10),
      if (tekananDarah?.isNotEmpty ?? false) 'blood_pressure': tekananDarah,
      if (spo2?.isNotEmpty ?? false) 'oxygen_saturation': spo2,
      if (gulaDarah?.isNotEmpty ?? false) 'blood_sugar_level': gulaDarah,
      if (kolesterol?.isNotEmpty ?? false) 'cholesterol_level': kolesterol,
      if (asamUrat?.isNotEmpty ?? false) 'uric_acid_level': asamUrat,
      'notes': (catatan == null || catatan.isEmpty) ? null : catatan,
    };

    print("DEBUG - Sending CREATE data: ${jsonEncode(dataPemeriksaan)}");

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/checkups'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dataPemeriksaan),
      );

      final responseBody = jsonDecode(response.body);
      return {
        'success': response.statusCode == 201,
        'message': responseBody['message'] ??
            (response.statusCode == 201
                ? 'Berhasil disimpan'
                : 'Gagal menyimpan'),
        'data': responseBody['data'],
      };
    } catch (e) {
      print('Error creating health record: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> updateCatatanKesehatan({
    required String recordId,
    required String patientId,
    required DateTime tanggalPemeriksaan,
    String? tekananDarah,
    String? spo2,
    String? gulaDarah,
    String? kolesterol,
    String? asamUrat,
    String? catatan,
  }) async {
    final String? token = await getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan, silakan login ulang.'
      };
    }

    Map<String, dynamic> dataPemeriksaan = {
      'checkup_date': tanggalPemeriksaan.toIso8601String().substring(0, 10),
    };

    if (tekananDarah != null)
      dataPemeriksaan['blood_pressure'] =
          tekananDarah.isNotEmpty ? tekananDarah : null;
    if (spo2 != null)
      dataPemeriksaan['oxygen_saturation'] = spo2.isNotEmpty ? spo2 : null;
    if (gulaDarah != null)
      dataPemeriksaan['blood_sugar_level'] =
          gulaDarah.isNotEmpty ? gulaDarah : null;
    if (kolesterol != null)
      dataPemeriksaan['cholesterol_level'] =
          kolesterol.isNotEmpty ? kolesterol : null;
    if (asamUrat != null)
      dataPemeriksaan['uric_acid_level'] =
          asamUrat.isNotEmpty ? asamUrat : null;
    if (catatan != null) dataPemeriksaan['notes'] = catatan;

    print(
        "DEBUG - Sending UPDATE data for ID $recordId: ${jsonEncode(dataPemeriksaan)}");

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/checkups/$recordId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dataPemeriksaan),
      );

      final responseBody = jsonDecode(response.body);
      return {
        'success': response.statusCode == 200,
        'message': responseBody['message'] ??
            (response.statusCode == 200
                ? 'Berhasil diperbarui'
                : 'Gagal memperbarui'),
        'data': responseBody['data'],
      };
    } catch (e) {
      print('Error updating health record: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }

  Future<List<HealthRecord>?> getCatatanKesehatan({String? patientId}) async {
    final String? token = await getToken();
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
          'Authorization': 'Bearer $token', // Gunakan token dinamis
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
              // Sesuaikan parsing dengan tipe data dari API jika berbeda
              spo2: data['oxygen_saturation'] != null
                  ? int.tryParse(data['oxygen_saturation'].toString())
                  : null,
              bloodSugar: data['blood_sugar_level'] != null ||
                      data['blood_sugar'] != null
                  ? int.tryParse(
                      (data['blood_sugar_level'] ?? data['blood_sugar'])
                          .toString())
                  : null,
              cholesterol: data['cholesterol_level'] != null ||
                      data['cholesterol'] != null
                  ? int.tryParse(
                      (data['cholesterol_level'] ?? data['cholesterol'])
                          .toString())
                  : null,
              uricAcid: data['uric_acid_level'] != null ||
                      data['uric_acid'] != null
                  ? double.tryParse(
                      (data['uric_acid_level'] ?? data['uric_acid']).toString())
                  : null,
              notes: data['notes'],
            );
          }).toList();
          return records;
        }
        print(
            "Format response tidak sesuai atau data kosong: ${response.body}");
        return [];
      } else {
        print('Gagal mengambil data: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error saat getCatatanKesehatan: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> deleteCatatanKesehatan(String recordId) async {
    final String? token = await getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Token tidak ditemukan, silakan login ulang.'
      };
    }

    final String apiUrl = '$_baseUrl/checkups/$recordId';
    print("DEBUG - Deleting record ID $recordId from API");

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        Map<String, dynamic>? responseBody;
        if (response.body.isNotEmpty) {
          responseBody = jsonDecode(response.body);
        }
        return {
          'success': true,
          'message': responseBody?['message'] ?? 'Catatan berhasil dihapus',
          'data': {'id': recordId}
        };
      } else {
        String errorMessage = 'Gagal menghapus catatan dari server.';
        if (response.body.isNotEmpty) {
          try {
            final errorData = jsonDecode(response.body);
            errorMessage = errorData['message'] ?? errorMessage;
          } catch (_) {
            // Keep default error message if body isn't valid JSON
          }
        }
        print(
            'Delete failed. Status: ${response.statusCode}. Body: ${response.body}');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Error deleting health record: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
    }
  }
}
