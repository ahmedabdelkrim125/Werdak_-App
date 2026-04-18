
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:quran/quran.dart' as quran;
// import '../data/models/plan_model.dart';

// class NotificationService {
//   NotificationService._();
//   static final instance = NotificationService._();

//   final _plugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     await _plugin.initialize(
//       const InitializationSettings(android: android, iOS: ios),
//     );
//     await _plugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   }

//   Future<void> scheduleForPlan(PlanModel plan) async {
//     await cancelForPlan(plan.id);

//     final timeParts = plan.notificationTime.split(':');
//     final hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);

//     for (int i = 0; i < plan.days.length; i++) {
//       final day = plan.days[i];
//       if (day.isCompleted || day.surahNumbers.isEmpty) continue;

//       final date = plan.startDate.add(Duration(days: i));

//       final scheduledDate = tz.TZDateTime(
//         tz.local,
//         date.year,
//         date.month,
//         date.day,
//         hour,
//         minute,
//       );

//       if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) continue;

//       final surahNames =
//           day.surahNumbers.map((n) => quran.getSurahNameArabic(n)).join(' + ');

//       final notifId = _notifId(plan.id, i);

//       await _plugin.zonedSchedule(
//         notifId,
//         'وردك - مراجعة اليوم ${day.dayNumber}',
//         surahNames,
//         scheduledDate,
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'werdak_daily',
//             'المراجعة اليومية',
//             channelDescription: 'إشعارات المراجعة اليومية للقرآن',
//             importance: Importance.high,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(''),
//           ),
//           iOS: DarwinNotificationDetails(
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//         ),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     }
//   }

//   Future<void> cancelForPlan(String planId) async {
//     for (int i = 0; i < 365; i++) {
//       await _plugin.cancel(_notifId(planId, i));
//     }
//   }

//   int _notifId(String planId, int dayIndex) {
//     return (planId.hashCode + dayIndex).abs() % 100000;
//   }
// }
// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:quran/quran.dart' as quran;
import '../data/models/plan_model.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

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
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleForPlan(PlanModel plan) async {
    await cancelForPlan(plan.id);

    final timeParts = plan.notificationTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // ✅ الإصلاح: نعمل normalize لـ startDate على منتصف الليل
    // المشكلة كانت إن startDate بيتحفظ بوقت الإنشاء (مثلاً 14:35)
    // فلما بنضيف 0 يوم، اليوم الأول بيطلع scheduledDate في الماضي
    // لو المنبّه على 08:00 والإنشاء كان الساعة 14:35
    final normalizedStart = DateTime(
      plan.startDate.year,
      plan.startDate.month,
      plan.startDate.day,
      // بدون ساعة أو دقيقة — يبدأ من 00:00
    );

    for (int i = 0; i < plan.days.length; i++) {
      final day = plan.days[i];
      if (day.isCompleted || day.surahNumbers.isEmpty) continue;

      // ✅ الآن كل يوم بيتحسب من منتصف الليل بالظبط
      final date = normalizedStart.add(Duration(days: i));

      final scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );

      // ✅ لو الوقت فات، اعمل skip — ده صح وبيشتغل صح دلوقتي
      // لأن اليوم الأول مش هيبقى في الماضي إلا لو الوقت المحدد فات فعلاً
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) continue;

      final surahNames =
          day.surahNumbers.map((n) => quran.getSurahNameArabic(n)).join(' + ');

      final notifId = _notifId(plan.id, i);

      await _plugin.zonedSchedule(
        notifId,
        'وردك - مراجعة اليوم ${day.dayNumber}',
        surahNames,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'werdak_daily',
            'المراجعة اليومية',
            channelDescription: 'إشعارات المراجعة اليومية للقرآن',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
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
      );
    }
  }

  Future<void> cancelForPlan(String planId) async {
    for (int i = 0; i < 365; i++) {
      await _plugin.cancel(_notifId(planId, i));
    }
  }

  int _notifId(String planId, int dayIndex) {
    return (planId.hashCode + dayIndex).abs() % 100000;
  }
}