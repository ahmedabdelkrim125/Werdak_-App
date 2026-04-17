// lib/data/models/weak_surah_model.dart

// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'weak_surah_model.g.dart';

@HiveType(typeId: 2)
class WeakSurahEntry extends HiveObject {
  @HiveField(0)
  int surahNumber;

  @HiveField(1)
  DateTime addedAt;

  @HiveField(2)
  bool isResolved; // لما تقول "خلاص حفظتها كويس"

  @HiveField(3)
  DateTime? resolvedAt;

  WeakSurahEntry({
    required this.surahNumber,
    required this.addedAt,
    this.isResolved = false,
    this.resolvedAt,
  });
}

@HiveType(typeId: 3)
class WeakSurahSettings extends HiveObject {
  /// نوع الإشعار: 'interval' أو 'fixed_times'
  @HiveField(0)
  String mode; // 'interval' | 'fixed_times'

  /// لو mode == 'interval': الفترة بين الإشعارات بالساعات (مثلاً 3 أو 5)
  @HiveField(1)
  int intervalHours;

  /// لو mode == 'fixed_times': قائمة الأوقات الثابتة "HH:mm"
  @HiveField(2)
  List<String> fixedTimes;

  /// الساعة اللي تبدأ منها الإشعارات في اليوم (مثلاً 7 صباحاً)
  @HiveField(3)
  int startHour;

  /// الساعة اللي بيوقف فيها الإشعارات (مثلاً 22 بعد الظهر)
  @HiveField(4)
  int endHour;

  /// هل الإشعارات شغالة؟
  @HiveField(5)
  bool isEnabled;

  WeakSurahSettings({
    this.mode = 'interval',
    this.intervalHours = 3,
    this.fixedTimes = const [],
    this.startHour = 7,
    this.endHour = 22,
    this.isEnabled = true,
  });
}
