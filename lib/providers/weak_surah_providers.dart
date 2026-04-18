// lib/providers/weak_surah_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/weak_surah_model.dart';
import '../data/repositories/weak_surah_repository.dart';
import '../services/weak_surah_notification_service.dart';

final _repo = WeakSurahRepository();

// ─── Active weak surahs ───────────────────────────────────────────────────

class WeakSurahsNotifier extends StateNotifier<List<WeakSurahEntry>> {
  WeakSurahsNotifier() : super(_repo.getActive());

  void _reload() => state = _repo.getActive();

  Future<void> add(int surahNumber) async {
    await _repo.addSurah(surahNumber);
    _reload();
    await _reschedule();
  }

  Future<void> remove(int surahNumber) async {
    await _repo.removeSurah(surahNumber);
    _reload();
    await _reschedule();
  }

  Future<void> markResolved(int surahNumber) async {
    await _repo.markResolved(surahNumber);
    _reload();
    await _reschedule();
  }

  bool isTracked(int surahNumber) => _repo.isTracked(surahNumber);

  Future<void> _reschedule() async {
    final settings = _repo.getSettings();
    final activeSurahs = _repo.getActive().map((e) => e.surahNumber).toList();
    if (settings.isEnabled && activeSurahs.isNotEmpty) {
      await WeakSurahNotificationService.instance
          .scheduleAll(settings, activeSurahs);
    } else {
      await WeakSurahNotificationService.instance.cancelAll();
    }
  }
}

final weakSurahsProvider =
    StateNotifierProvider<WeakSurahsNotifier, List<WeakSurahEntry>>(
  (ref) => WeakSurahsNotifier(),
);

// ─── Settings ─────────────────────────────────────────────────────────────

class WeakSurahSettingsNotifier extends StateNotifier<WeakSurahSettings> {
  WeakSurahSettingsNotifier() : super(_repo.getSettings());

  Future<void> update(WeakSurahSettings newSettings) async {
    await _repo.saveSettings(newSettings);
    state = newSettings;
    // إعادة جدولة الإشعارات
    final activeSurahs =
        _repo.getActive().map((e) => e.surahNumber).toList();
    if (newSettings.isEnabled && activeSurahs.isNotEmpty) {
      await WeakSurahNotificationService.instance
          .scheduleAll(newSettings, activeSurahs);
    } else {
      await WeakSurahNotificationService.instance.cancelAll();
    }
  }
}

final weakSurahSettingsProvider =
    StateNotifierProvider<WeakSurahSettingsNotifier, WeakSurahSettings>(
  (ref) => WeakSurahSettingsNotifier(),
);
