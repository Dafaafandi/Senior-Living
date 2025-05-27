import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav_bar.dart';
import '../utils/date_utils.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final int? userAge; // Make nullable since age might be null from User model
  final String healthStatus;

  const HomePage({
    super.key,
    required this.userName,
    this.userAge, // Remove required since it's nullable
    required this.healthStatus,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentTime;
  String? _userName;
  int? _userAge;
  String? _healthStatus;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _userName = widget.userName;
    _userAge = widget.userAge;
    _healthStatus = widget.healthStatus;
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _userName = args['name'] as String? ?? _userName;
        _healthStatus = args['status'] as String? ?? _healthStatus;
      });
    }
  }

  void _updateTime() {
    // Format: Hari, DD MMMM YYYY HH:mm (e.g., Senin, 07 April 2025 22:10)
    _currentTime = DateFormat(
      'EEEE, dd MMMM yyyy HH:mm',
      'id_ID',
    ).format(DateTime.now());
  }

  String get _ageText {
    if (_userAge != null) {
      return "$_userAge Tahun";
    }
    return "Umur tidak diketahui";
  }

  // Add this method to get patient ID
  Future<String?> getLoggedInUserPatientId() async {
    // TODO: Implement your actual logic to get patient ID
    // This could involve:
    // 1. Getting it from secure storage
    // 2. Getting it from your auth state
    // 3. Making an API call

    // For now, returning a mock value
    return "1"; // Replace with actual implementation
  }

  Future<void> _performLogout() async {
    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Updated Header with Logout
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
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/notification'),
                        icon: const Icon(Icons.notifications,
                            color: Colors.grey, size: 28),
                      ),
                      IconButton(
                        onPressed: _performLogout,
                        icon: const Icon(Icons.logout,
                            color: Colors.grey, size: 28),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dashboard
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors
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
                            _userName ?? "Pengguna",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17, // Sedikit lebih besar
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _ageText,
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
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/health'),
                              ),
                              const SizedBox(width: 8),
                              _buildInfoButton(
                                context: context,
                                label: "Jadwal",
                                icon: Icons.calendar_today_outlined,
                                onPressed: () => Navigator.pushNamed(
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
                        color: _healthStatus == "Normal"
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _healthStatus ?? "Status tidak diketahui",
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

  // Also update the quick access button navigation
  Widget _quickAccessButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: label == "Catat Pemeriksaan"
          ? () async {
              String? userPatientId = await getLoggedInUserPatientId();

              if (!mounted) return;

              if (userPatientId != null && userPatientId.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  '/health',
                  arguments: {'patientId': userPatientId},
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Tidak dapat menemukan data pasien untuk user ini.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          : onTap,
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

  // Update the _buildInfoButton method
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
      onPressed: label == "Data Kesehatan"
          ? () async {
              String? userPatientId = await getLoggedInUserPatientId();

              if (!mounted) return; // Check if widget is still mounted

              if (userPatientId != null && userPatientId.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  '/health',
                  arguments: {'patientId': userPatientId},
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Tidak dapat menemukan data pasien untuk user ini.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }
          : onPressed,
    );
  }
}
