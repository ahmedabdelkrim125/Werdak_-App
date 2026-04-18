// lib/data/repositories/weak_surah_repository.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../models/weak_surah_model.dart';

class WeakSurahRepository {
  static const String _entriesBox = 'weak_surahs';
  static const String _settingsBox = 'weak_surah_settings';
  static const String _settingsKey = 'settings';

  // ─── Boxes ────────────────────────────────────────────────────────────────

  static Box<WeakSurahEntry> get _entries =>
      Hive.box<WeakSurahEntry>(_entriesBox);

  static Box<WeakSurahSettings> get _settingsStore =>
      Hive.box<WeakSurahSettings>(_settingsBox);

  static Future<void> openBoxes() async {
    await Hive.openBox<WeakSurahEntry>(_entriesBox);
    await Hive.openBox<WeakSurahSettings>(_settingsBox);
  }

  // ─── Entries ──────────────────────────────────────────────────────────────

  List<WeakSurahEntry> getActive() => _entries.values
      .where((e) => !e.isResolved)
      .toList()
    ..sort((a, b) => a.addedAt.compareTo(b.addedAt));

  List<WeakSurahEntry> getResolved() => _entries.values
      .where((e) => e.isResolved)
      .toList()
    ..sort((a, b) => b.resolvedAt!.compareTo(a.resolvedAt!));

  bool isTracked(int surahNumber) =>
      _entries.values.any((e) => e.surahNumber == surahNumber && !e.isResolved);

  Future<void> addSurah(int surahNumber) async {
    // لو موجودة قبل كده ومحلولة، شيلها وضيفها من أول
    final existing = _entries.values
        .where((e) => e.surahNumber == surahNumber)
        .toList();
    for (final e in existing) {
      await e.delete();
    }
    await _entries.add(WeakSurahEntry(
      surahNumber: surahNumber,
      addedAt: DateTime.now(),
    ));
  }

  Future<void> removeSurah(int surahNumber) async {
    final toDelete = _entries.values
        .where((e) => e.surahNumber == surahNumber && !e.isResolved)
        .toList();
    for (final e in toDelete) {
      await e.delete();
    }
  }

  Future<void> markResolved(int surahNumber) async {
    final entry = _entries.values
        .firstWhere((e) => e.surahNumber == surahNumber && !e.isResolved);
    entry.isResolved = true;
    entry.resolvedAt = DateTime.now();
    await entry.save();
  }

  // ─── Settings ─────────────────────────────────────────────────────────────

  WeakSurahSettings getSettings() {
    return _settingsStore.get(_settingsKey) ?? WeakSurahSettings();
  }

  Future<void> saveSettings(WeakSurahSettings settings) async {
    await _settingsStore.put(_settingsKey, settings);
  }
}
