import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/schedule_item.dart';

const String schedulesBoxName = 'schedules';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late final Box<ScheduleItem> scheduleBox;

  @override
  void initState() {
    super.initState();
    scheduleBox = Hive.box<ScheduleItem>(schedulesBoxName);
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade600;
    final Color lightGreenBackground = Colors.green.shade50;
    final Color darkGreenText = Colors.green.shade800;
    final Color orangeButton = Colors.orange.shade600;
    final Color redButton = Colors.red.shade500;
    final Color checkmarkColor = Colors.green.shade500;
    final Color cardBackgroundColor = Colors.white;
    final Color completedCardBackgroundColor = Colors.grey.shade100;
    final double completedOpacity = 0.6;
    final Color scaffoldBackgroundColor = Colors.grey.shade50;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Jadwal',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<ScheduleItem>>(
        valueListenable: scheduleBox.listenable(),
        builder: (context, box, _) {
          var items =
              box.values.toList()..sort((a, b) => a.time.compareTo(b.time));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Jadwal & Pengingat Obat",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Tambah',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () => _showScheduleFormDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    items.isEmpty
                        ? const Center(
                          child: Text(
                            'Belum ada jadwal.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            0,
                            16.0,
                            16.0,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return _buildScheduleCard(
                              items[index],
                              primaryColor,
                              lightGreenBackground,
                              darkGreenText,
                              orangeButton,
                              redButton,
                              checkmarkColor,
                              cardBackgroundColor,
                              completedCardBackgroundColor,
                              completedOpacity,
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showScheduleFormDialog({ScheduleItem? itemToEdit}) async {
    final timeController = TextEditingController(text: itemToEdit?.time);
    final titleController = TextEditingController(text: itemToEdit?.title);
    final detailsController = TextEditingController(text: itemToEdit?.details);
    final notesController = TextEditingController(text: itemToEdit?.notes);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              itemToEdit == null ? 'Tambah Jadwal Baru' : 'Edit Jadwal',
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Waktu (HH:MM)',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Waktu tidak boleh kosong'
                                  : null,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Judul Kegiatan/Obat',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Judul tidak boleh kosong'
                                  : null,
                    ),
                    TextFormField(
                      controller: detailsController,
                      decoration: const InputDecoration(
                        labelText: 'Detail (Opsional)',
                      ),
                    ),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Catatan (Opsional)',
                      ),
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
                    final time = timeController.text;
                    final title = titleController.text;
                    final details =
                        detailsController.text.isNotEmpty
                            ? detailsController.text
                            : null;
                    final notes =
                        notesController.text.isNotEmpty
                            ? notesController.text
                            : null;

                    // Create new item or prepare edited item
                    ScheduleItem itemToSave;
                    if (itemToEdit == null) {
                      itemToSave = ScheduleItem(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        time: time,
                        title: title,
                        details: details,
                        notes: notes,
                      );
                    } else {
                      itemToEdit.time = time;
                      itemToEdit.title = title;
                      itemToEdit.details = details;
                      itemToEdit.notes = notes;
                      itemToSave = itemToEdit;
                    }

                    // Save to Hive
                    await scheduleBox.put(itemToSave.id, itemToSave);

                    // Safely close dialog
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (Navigator.of(ctx).canPop()) {
                          Navigator.of(ctx).pop();
                        }
                      });
                    }
                  }
                },
              ),
            ],
          ),
    );

    timeController.dispose();
    titleController.dispose();
    detailsController.dispose();
    notesController.dispose();
  }

  Future<void> _deleteScheduleItem(String id) async {
    final itemToDelete = scheduleBox.get(id);
    if (itemToDelete == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: Text(
              'Anda yakin ingin menghapus jadwal "${itemToDelete.title}"?',
            ),
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
      scheduleBox.delete(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal "${itemToDelete.title}" dihapus')),
        );
      }
    }
  }

  void _toggleCompleteStatus(String id) {
    final item = scheduleBox.get(id);
    if (item != null) {
      setState(() {
        item.isCompleted = !item.isCompleted;
        item.save();
      });
    }
  }

  Widget _buildScheduleCard(
    ScheduleItem item,
    Color primaryColor,
    Color lightGreenBackground,
    Color darkGreenText,
    Color orangeButton,
    Color redButton,
    Color checkmarkColor,
    Color cardBackgroundColor,
    Color completedCardBackgroundColor,
    double completedOpacity,
  ) {
    bool isCompleted = item.isCompleted;
    double currentOpacity = isCompleted ? completedOpacity : 1.0;

    return Opacity(
      opacity: 1.0,
      child: InkWell(
        onTap: () => _toggleCompleteStatus(item.id),
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14.0),
        child: Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          color:
              isCompleted ? completedCardBackgroundColor : cardBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          if (item.details != null &&
                              item.details!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.details!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (item.isCompleted) ...[
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 28,
                      ),
                    ],
                  ],
                ),
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Catatan: ${item.notes!}",
                      style: TextStyle(fontSize: 13, color: Colors.green[800]),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildActionButton(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      color: orangeButton,
                      onPressed:
                          () => _showScheduleFormDialog(itemToEdit: item),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      label: 'Hapus',
                      icon: Icons.delete_outline,
                      color: redButton,
                      onPressed: () => _deleteScheduleItem(item.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        minimumSize: const Size(0, 34),
      ),
    );
  }
}
