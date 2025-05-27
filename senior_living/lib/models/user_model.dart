// lib/models/user_model.dart

class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt; // Bisa jadi null jika belum diverifikasi
  final String? birthDate;
  final int? age;
  final int? patientId;
  final String createdAt;
  final String updatedAt;
  // Tambahkan field lain jika ada, misalnya 'patientId', dll.
  // final String? patientId; // Atau int, sesuaikan dengan tipe data dari API

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.birthDate,
    this.age,
    this.patientId,
    required this.createdAt,
    required this.updatedAt,
    // this.patientId,
  });

  /// Creates a User instance from JSON map received from API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      birthDate: json['birth_date'] as String?,
      age: json['age'] as int?, // Age calculated from backend
      patientId:
          json['patient_id'] as int?, // Patient ID if user has patient profile
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  // Method untuk mengonversi instance User menjadi Map (JSON)
  // Berguna jika Anda perlu mengirim objek User kembali ke API (meskipun jarang untuk model User)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'birth_date': birthDate,
      'age': age,
      'patient_id': patientId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      // 'patient_id': patientId, // Uncomment jika ada field 'patient_id'
    };
  }
}
