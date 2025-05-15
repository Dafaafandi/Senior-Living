import 'package:hive/hive.dart';

part 'schedule_item.g.dart';

@HiveType(typeId: 0)
class ScheduleItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String time;

  @HiveField(2)
  String title;

  @HiveField(3)
  String? details;

  @HiveField(4)
  String? notes;

  @HiveField(5)
  bool isCompleted;

  ScheduleItem({
    required this.id,
    required this.time,
    required this.title,
    this.details,
    this.notes,
    this.isCompleted = false,
  });
}
