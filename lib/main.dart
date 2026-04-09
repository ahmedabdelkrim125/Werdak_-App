import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/local/hive_boxes.dart';
import 'data/models/plan_model.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Init timezone
    tz.initializeTimeZones();

    // Init Hive
    await Hive.initFlutter();
    Hive.registerAdapter(PlanModelAdapter());
    Hive.registerAdapter(DayEntryAdapter());
    await HiveBoxes.openBoxes();

    // Init Notifications
    await NotificationService.instance.init();
  } catch (e, stack) {
    debugPrint('❌ Startup error: $e');
    debugPrint('Stack: $stack');
  }

  runApp(const ProviderScope(child: WerdakApp()));
}

class WerdakApp extends StatelessWidget {
  const WerdakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'وردك',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
