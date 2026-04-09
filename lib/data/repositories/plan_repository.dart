// lib/data/repositories/plan_repository.dart

import 'package:uuid/uuid.dart';
import '../local/hive_boxes.dart';
import '../models/plan_model.dart';

class PlanRepository {
  static const _uuid = Uuid();

  /// Core division logic:
  /// Distributes [surahs] across [days] as evenly as possible.
  /// Extra surahs (remainder) go to the first days.
  static List<DayEntry> buildDayEntries(List<int> surahs, int days) {
    final total = surahs.length;
    final base = total ~/ days; // سور لكل يوم كحد أدنى
    final extra = total % days; // أيام هتاخد سورة زيادة

    final entries = <DayEntry>[];
    int surahIndex = 0;

    for (int day = 1; day <= days; day++) {
      final count = base + (day <= extra ? 1 : 0);
      final daysSurahs = surahs.sublist(
        surahIndex,
        (surahIndex + count).clamp(0, total),
      );
      surahIndex += count;

      // لو الأيام أكتر من السور، بعض الأيام هتبقى مراجعة حرة (قايمة فاضية)
      entries.add(DayEntry(dayNumber: day, surahNumbers: daysSurahs));
    }

    return entries;
  }

  Future<PlanModel> createPlan({
    required String name,
    required List<int> surahNumbers,
    required int days,
    required String notificationTime,
  }) async {
    final id = _uuid.v4();
    final dayEntries = buildDayEntries(surahNumbers, days);

    final plan = PlanModel(
      id: id,
      name: name,
      surahNumbers: surahNumbers,
      totalDays: days,
      notificationTime: notificationTime,
      startDate: DateTime.now(),
      days: dayEntries,
    );

    await HiveBoxes.plans.put(id, plan);
    return plan;
  }

  List<PlanModel> getAllPlans() {
    return HiveBoxes.plans.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  PlanModel? getPlan(String id) => HiveBoxes.plans.get(id);

  Future<void> markDayComplete(String planId, int dayIndex) async {
    final plan = HiveBoxes.plans.get(planId);
    if (plan == null) return;

    plan.days[dayIndex].isCompleted = true;
    plan.days[dayIndex].completedAt = DateTime.now();

    if (plan.days.every((d) => d.isCompleted || d.surahNumbers.isEmpty)) {
      plan.isCompleted = true;
    }

    await plan.save();
  }

  Future<void> deletePlan(String id) async {
    await HiveBoxes.plans.delete(id);
  }
}
