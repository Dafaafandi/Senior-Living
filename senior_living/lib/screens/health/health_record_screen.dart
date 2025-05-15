// lib/screens/health/health_record_screen.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/health_record.dart';
import '../../main.dart'; 

class HealthRecordScreen extends StatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  State<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends State<HealthRecordScreen> {
  late final Box<HealthRecord> healthRecordBox;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    healthRecordBox = Hive.box<HealthRecord>(healthRecordsBoxName);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade600;

    return Scaffold(
      // backgroundColor sudah di set global di main.dart
      appBar: AppBar(
        title: const Text('Catatan Kesehatan'),
        // AppBar Theme sudah di set global
      ),
      body: ValueListenableBuilder<Box<HealthRecord>>(
        valueListenable: healthRecordBox.listenable(),
        builder: (context, box, _) {
          // Ambil data, urutkan dari terbaru ke terlama
          var records = box.values.toList()
            ..sort((a, b) => b.date.compareTo(a.date));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pencatatan Kesehatan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 18, color: Colors.white),
                      label: const Text(
                        'Tambah',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () => _showAddRecordDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: records.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada catatan kesehatan.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          return _buildHealthRecordCard(records[index], primaryColor);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHealthRecordCard(HealthRecord record, Color primaryColor) {
    final Color cardBackgroundColor = Colors.white;
    final Color orangeButton = Colors.orange.shade600;
    final Color detailButtonColor = Colors.blue.shade600;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      color: cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dateFormat.format(record.date), // Format tanggal
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildReadingRow("Tekanan Darah:", record.bloodPressure ?? '-', record.getBloodPressureStatus()),
            const SizedBox(height: 8),
            _buildReadingRow("SpO2:", record.spo2 != null ? "${record.spo2}%" : '-', record.getSpo2Status()),
            const SizedBox(height: 8),
            _buildReadingRow("Gula Darah:", record.bloodSugar != null ? "${record.bloodSugar} mg/dL" : '-', record.getBloodSugarStatus()),
            if (record.notes != null && record.notes!.isNotEmpty) ...[
               const SizedBox(height: 12),
               Text("Catatan: ${record.notes!}", style: TextStyle(fontSize: 13, color: Colors.grey[700])),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 _buildActionButton(
                   label: 'Lihat Grafik',
                   icon: Icons.show_chart, // Atau Icons.timeline
                   color: orangeButton,
                   onPressed: () {
                     // TODO: Implementasi navigasi/tampilkan grafik
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Fitur Grafik belum tersedia')),
                     );
                   },
                 ),
                 const SizedBox(width: 8),
                _buildActionButton(
                  label: 'Detail',
                  icon: Icons.info_outline,
                  color: detailButtonColor,
                  onPressed: () {
                    // TODO: Implementasi navigasi/tampilkan detail
                     _showRecordDetailDialog(record); // Tampilkan detail dalam dialog
                  },
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                   label: 'Hapus',
                   icon: Icons.delete_outline,
                   color: Colors.red.shade500,
                   onPressed: () => _deleteRecord(record.id),
                 ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingRow(String label, String value, String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'normal':
      case 'optimal':
        statusColor = Colors.green.shade600;
        break;
      case 'waspada':
      case 'normal tinggi':
        statusColor = Colors.orange.shade700;
        break;
      case 'hipertensi':
      case 'tinggi':
      case 'rendah': // Mungkin rendah juga perlu waspada
        statusColor = Colors.red.shade600;
        break;
      default:
        statusColor = Colors.grey.shade600;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible( // Agar teks tidak overflow jika panjang
          child: Text(
            "$label $value",
            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
          ),
        ),
        if (status != '-') // Hanya tampilkan jika ada status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
      ],
    );
  }

  // Fungsi untuk menampilkan dialog tambah data
 Future<void> _showAddRecordDialog({HealthRecord? recordToEdit}) async {
    final formKey = GlobalKey<FormState>();
    final dateController = TextEditingController(text: recordToEdit != null ? _dateFormat.format(recordToEdit.date) : _dateFormat.format(DateTime.now()));
    final bpController = TextEditingController(text: recordToEdit?.bloodPressure);
    final spo2Controller = TextEditingController(text: recordToEdit?.spo2?.toString());
    final sugarController = TextEditingController(text: recordToEdit?.bloodSugar?.toString());
    final notesController = TextEditingController(text: recordToEdit?.notes);
    DateTime selectedDate = recordToEdit?.date ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(recordToEdit == null ? 'Tambah Catatan Kesehatan' : 'Edit Catatan'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true, // Buat read-only agar dipilih pakai date picker
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(const Duration(days: 30)), // Batasi hingga hari ini + 30 hari
                       locale: const Locale('id', 'ID'), // Set locale ke Indonesia
                    );
                    if (picked != null && picked != selectedDate) {
                      setState(() { // Perlu setState jika dialog ini stateful, atau handle state di luar
                        selectedDate = picked;
                        dateController.text = _dateFormat.format(selectedDate);
                      });
                    }
                  },
                   validator: (value) => value == null || value.isEmpty ? 'Tanggal tidak boleh kosong' : null,
                ),
                 TextFormField(
                  controller: bpController,
                  decoration: const InputDecoration(labelText: 'Tekanan Darah (cth: 120/80)'),
                   keyboardType: TextInputType.text, // Atau number jika hanya angka
                 ),
                 TextFormField(
                   controller: spo2Controller,
                   decoration: const InputDecoration(labelText: 'SpO2 (%)'),
                   keyboardType: TextInputType.number,
                 ),
                 TextFormField(
                   controller: sugarController,
                   decoration: const InputDecoration(labelText: 'Gula Darah (mg/dL)'),
                   keyboardType: TextInputType.number,
                 ),
                  TextFormField(
                   controller: notesController,
                   decoration: const InputDecoration(labelText: 'Catatan (Opsional)'),
                   keyboardType: TextInputType.multiline,
                    maxLines: null, // Agar bisa multiple lines
                 ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            child: const Text('Simpan'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                 final newRecord = HealthRecord(
                   id: recordToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                   date: selectedDate,
                   bloodPressure: bpController.text.isNotEmpty ? bpController.text : null,
                   spo2: spo2Controller.text.isNotEmpty ? int.tryParse(spo2Controller.text) : null,
                   bloodSugar: sugarController.text.isNotEmpty ? int.tryParse(sugarController.text) : null,
                   notes: notesController.text.isNotEmpty ? notesController.text : null,
                 );

                 await healthRecordBox.put(newRecord.id, newRecord);

                 if (mounted) Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
 }


  // Fungsi helper untuk tombol aksi di card
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 14), // Ukuran ikon lebih kecil
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Padding disesuaikan
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500), // Font lebih kecil
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        minimumSize: const Size(0, 30), // Tinggi minimum tombol
      ),
    );
  }

  // Fungsi untuk menghapus record
  Future<void> _deleteRecord(String id) async {
     final record = healthRecordBox.get(id);
     if (record == null) return;

     final confirm = await showDialog<bool>(
       context: context,
       builder: (ctx) => AlertDialog(
         title: const Text('Konfirmasi Hapus'),
         content: Text('Anda yakin ingin menghapus catatan kesehatan tanggal ${_dateFormat.format(record.date)}?'),
         actions: <Widget>[
           TextButton(
             child: const Text('Batal'),
             onPressed: () => Navigator.of(ctx).pop(false),
           ),
           TextButton(
             style: TextButton.styleFrom(foregroundColor: Colors.red),
             child: const Text('Hapus'),
             onPressed: () => Navigator.of(ctx).pop(true),
           ),
         ],
       ),
     );

     if (confirm == true) {
       await healthRecordBox.delete(id);
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Catatan tanggal ${_dateFormat.format(record.date)} dihapus')),
         );
       }
     }
   }

  // Fungsi untuk menampilkan detail record dalam dialog
  Future<void> _showRecordDetailDialog(HealthRecord record) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Detail Catatan - ${_dateFormat.format(record.date)}'),
        content: SingleChildScrollView(
          child: ListBody( // Menggunakan ListBody agar rapi
            children: <Widget>[
              _detailItem('Tekanan Darah:', '${record.bloodPressure ?? '-'} (${record.getBloodPressureStatus()})'),
              _detailItem('SpO2:', record.spo2 != null ? '${record.spo2}% (${record.getSpo2Status()})' : '-'),
              _detailItem('Gula Darah:', record.bloodSugar != null ? '${record.bloodSugar} mg/dL (${record.getBloodSugarStatus()})' : '-'),
              if (record.notes != null && record.notes!.isNotEmpty)
                _detailItem('Catatan:', record.notes!),
            ],
          ),
        ),
        actions: <Widget>[
           TextButton(
             child: const Text('Edit'),
             onPressed: () {
               Navigator.of(ctx).pop(); // Tutup dialog detail dulu
               _showAddRecordDialog(recordToEdit: record); // Buka dialog edit
             },
           ),
          TextButton(
            child: const Text('Tutup'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Helper widget untuk item detail di dialog
  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14), // Style default teks
          children: <TextSpan>[
            TextSpan(text: label, style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }
}