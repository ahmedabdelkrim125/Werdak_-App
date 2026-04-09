// lib/providers/plan_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/plan_model.dart';
import '../data/repositories/plan_repository.dart';
import '../services/notification_service.dart';

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository();
});

final allPlansProvider = Provider<List<PlanModel>>((ref) {
  return ref.watch(planRepositoryProvider).getAllPlans();
});

final planByIdProvider = Provider.family<PlanModel?, String>((ref, id) {
  return ref.watch(planRepositoryProvider).getPlan(id);
});

// Notifier for creating a new plan
class CreatePlanNotifier extends StateNotifier<AsyncValue<PlanModel?>> {
  final PlanRepository _repo;
  CreatePlanNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<PlanModel?> create({
    required String name,
    required List<int> surahNumbers,
    required int days,
    required String notificationTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      final plan = await _repo.createPlan(
        name: name,
        surahNumbers: surahNumbers,
        days: days,
        notificationTime: notificationTime,
      );
      await NotificationService.instance.scheduleForPlan(plan);
      state = AsyncValue.data(plan);
      return plan;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final createPlanProvider =
    StateNotifierProvider<CreatePlanNotifier, AsyncValue<PlanModel?>>((ref) {
  return CreatePlanNotifier(ref.read(planRepositoryProvider));
});

// Mark day complete
class DayCompletionNotifier extends StateNotifier<bool> {
  final PlanRepository _repo;
  DayCompletionNotifier(this._repo) : super(false);

  Future<void> markComplete(String planId, int dayIndex) async {
    await _repo.markDayComplete(planId, dayIndex);
    state = true;
  }
}

final dayCompletionProvider =
    StateNotifierProvider<DayCompletionNotifier, bool>((ref) {
  return DayCompletionNotifier(ref.read(planRepositoryProvider));
});
