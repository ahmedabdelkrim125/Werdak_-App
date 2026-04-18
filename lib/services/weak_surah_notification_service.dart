// lib/services/weak_surah_notification_service.dart
//
// يستخدم flutter_local_notifications لجدولة إشعارات دورية للسور الضعيفة.
// بيشتغل بنظامين:
//   - interval: كل X ساعات بين startHour و endHour
//   - fixed_times: في أوقات ثابتة يختارها المستخدم

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quran/quran.dart' as quran;
import 'package:timezone/timezone.dart' as tz;
import '../data/models/weak_surah_model.dart';

class WeakSurahNotificationService {
  WeakSurahNotificationService._();
  static final instance = WeakSurahNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  // IDs محجوزة للسور الضعيفة: 2000 → 2999
  static const int _baseId = 2000;
  static const int _maxNotifications = 200;

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
  }

  Future<void> cancelAll() async {
    for (int i = _baseId; i < _baseId + _maxNotifications; i++) {
      await _plugin.cancel(i);
    }
  }

  Future<void> scheduleAll(
      WeakSurahSettings settings, List<int> surahNumbers) async {
    await cancelAll();
    if (surahNumbers.isEmpty || !settings.isEnabled) return;

    // بنجمع كل الأوقات المطلوبة خلال أسبوع (7 أيام قادمين)
    final times = _buildScheduleTimes(settings);

    int notifId = _baseId;
    int surahCursor = 0;

    for (final scheduledTime in times) {
      if (notifId >= _baseId + _maxNotifications) break;

      final surahNumber = surahNumbers[surahCursor % surahNumbers.length];
      surahCursor++;

      final surahName = quran.getSurahNameArabic(surahNumber);
      final verseCount = quran.getVerseCount(surahNumber);

      await _plugin.zonedSchedule(
        notifId++,
        '🕌 مراجعة سورة $surahName',
        'سورة $surahName · $verseCount آية · اضغط للمراجعة',
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weak_surahs',
            'مراجعة السور الضعيفة',
            channelDescription: 'تذكير بمراجعة السور التي تحتاج تقوية',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'weak_surah:$surahNumber',
      );
    }
  }

  /// بيبني قائمة بأوقات الإشعارات خلال 7 أيام
  List<tz.TZDateTime> _buildScheduleTimes(WeakSurahSettings settings) {
    final now = tz.TZDateTime.now(tz.local);
    final times = <tz.TZDateTime>[];

    for (int dayOffset = 0; dayOffset <= 7; dayOffset++) {
      final baseDate = now.add(Duration(days: dayOffset));

      if (settings.mode == 'interval') {
        // كل X ساعات من startHour لـ endHour
        int hour = settings.startHour;
        while (hour <= settings.endHour) {
          final t = tz.TZDateTime(
            tz.local,
            baseDate.year,
            baseDate.month,
            baseDate.day,
            hour,
            0,
          );
          if (t.isAfter(now)) times.add(t);
          hour += settings.intervalHours;
        }
      } else {
        // أوقات ثابتة
        for (final timeStr in settings.fixedTimes) {
          final parts = timeStr.split(':');
          if (parts.length != 2) continue;
          final h = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          if (h == null || m == null) continue;
          final t = tz.TZDateTime(
            tz.local,
            baseDate.year,
            baseDate.month,
            baseDate.day,
            h,
            m,
          );
          if (t.isAfter(now)) times.add(t);
        }
      }
    }

    times.sort();
    return times;
  }
}
