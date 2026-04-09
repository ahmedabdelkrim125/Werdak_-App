// // lib/services/notification_service.dart

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

//   /// Schedule one notification per day for the entire plan
//   Future<void> scheduleForPlan(PlanModel plan) async {
//     await cancelForPlan(plan.id);

//     final timeParts = plan.notificationTime.split(':');
//     final hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);

//     for (int i = 0; i < plan.days.length; i++) {
//       final day = plan.days[i];
//       if (day.isCompleted || day.surahNumbers.isEmpty) continue;

//       final scheduledDate = tz.TZDateTime.from(
//         plan.startDate.add(Duration(days: i)),
//         tz.local,
//       ).copyWith(hour: hour, minute: minute, second: 0);

//       if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) continue;

//       final surahNames = day.surahNumbers
//           .map((n) => quran.getSurahNameArabic(n))
//           .join(' + ');

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
//     // Cancel up to 365 possible notifications per plan
//     for (int i = 0; i < 365; i++) {
//       await _plugin.cancel(_notifId(planId, i));
//     }
//   }

//   int _notifId(String planId, int dayIndex) {
//     return (planId.hashCode + dayIndex).abs() % 100000;
//   }
// }
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

    for (int i = 0; i < plan.days.length; i++) {
      final day = plan.days[i];
      if (day.isCompleted || day.surahNumbers.isEmpty) continue;

      final date = plan.startDate.add(Duration(days: i));

      final scheduledDate = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );

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
