import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String healthStatus;

  const HomePage({
    super.key,
    required this.userName,
    required this.userAge,
    required this.healthStatus,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    // Inisialisasi waktu saat widget pertama kali dibuat
    _updateTime();
    // Pertimbangkan menggunakan Timer.periodic jika ingin update live,
    // tapi itu akan lebih kompleks dan memakan baterai.
  }

  void _updateTime() {
    // Format: Hari, DD MMMM YYYY HH:mm (e.g., Senin, 07 April 2025 22:10)
    _currentTime = DateFormat(
      'EEEE, dd MMMM yyyy HH:mm',
      'id_ID',
    ).format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(), // Navigasi bawah tetap
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Greeting, Real-time Date/Time, Notification)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Halo, Selamat Datang!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Sesuaikan warna jika perlu
                        ),
                      ),
                      const SizedBox(height: 4), // Spasi kecil
                      Text(
                        _currentTime, // Tampilkan waktu yang diformat
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/notification',
                      ); // Navigasi notifikasi
                    },
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dashboard
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      Colors
                          .blue, // Warna background kartu (sesuaikan dari Figma jika beda)
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // Contoh shadow (sesuaikan dari Figma)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Foto Profil
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      // Ganti dengan Image.network atau asset jika foto dinamis
                      child: Icon(Icons.person, size: 30, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    // Nama, Umur, Tombol
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName, // Gunakan nama dari argumen
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17, // Sedikit lebih besar
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${widget.userAge} Tahun", // Gunakan umur dari argumen
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tombol Lihat Data & Jadwal
                          Row(
                            children: [
                              _buildInfoButton(
                                context: context,
                                label: "Data Kesehatan",
                                icon: Icons.favorite_border,
                                onPressed:
                                    () =>
                                        Navigator.pushNamed(context, '/health'),
                              ),
                              const SizedBox(width: 8),
                              _buildInfoButton(
                                context: context,
                                label: "Jadwal",
                                icon: Icons.calendar_today_outlined,
                                onPressed:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/schedule',
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Status Kesehatan (contoh, bisa dibuat lebih dinamis)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        // Ganti warna berdasarkan status
                        color:
                            widget.healthStatus == "Normal"
                                ? Colors.green
                                : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.healthStatus, // Gunakan status dari argumen
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24), // Spasi setelah kartu info
              // Akses Cepat
              const Text(
                "Akses Cepat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quickAccessButton(
                    context,
                    Icons.edit_calendar,
                    "Tambah Jadwal",
                    () => Navigator.pushNamed(context, '/schedule'),
                  ),
                  _quickAccessButton(
                    context,
                    Icons.assignment_add,
                    "Catat Pemeriksaan",
                    () => Navigator.pushNamed(context, '/health'),
                  ),
                  _quickAccessButton(
                    context,
                    Icons.history,
                    "Riwayat Kontrol",
                    () => Navigator.pushNamed(context, '/history'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickAccessButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Warna teks dan ikon tombol
        backgroundColor: Colors.white.withOpacity(
          0.2,
        ), // Background semi-transparan
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        iconColor: Colors.white, // Pastikan ikon juga putih
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Kurangi area tap
      ),
      icon: Icon(icon, size: 14),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
