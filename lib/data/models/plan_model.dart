// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'plan_model.g.dart';

@HiveType(typeId: 0)
class PlanModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<int> surahNumbers; // e.g. [1, 2, 3]

  @HiveField(3)
  int totalDays;

  @HiveField(4)
  String notificationTime; // "HH:mm"

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  List<DayEntry> days;

  @HiveField(7)
  bool isCompleted;

  PlanModel({
    required this.id,
    required this.name,
    required this.surahNumbers,
    required this.totalDays,
    required this.notificationTime,
    required this.startDate,
    required this.days,
    this.isCompleted = false,
  });

  int get completedDays => days.where((d) => d.isCompleted).length;
  double get progress => totalDays == 0 ? 0 : completedDays / totalDays;

  int? get todayIndex {
    final now = DateTime.now();
    final diff = now.difference(startDate).inDays;
    if (diff < 0 || diff >= totalDays) return null;
    return diff;
  }
}

@HiveType(typeId: 1)
class DayEntry extends HiveObject {
  @HiveField(0)
  int dayNumber; // 1-based

  @HiveField(1)
  List<int> surahNumbers; // which surahs to review this day

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime? completedAt;

  DayEntry({
    required this.dayNumber,
    required this.surahNumbers,
    this.isCompleted = false,
    this.completedAt,
  });
}
