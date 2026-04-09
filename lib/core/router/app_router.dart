// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/create_plan/surah_picker_screen.dart';
import '../../features/create_plan/plan_setup_screen.dart';
import '../../features/create_plan/plan_preview_screen.dart';
import '../../features/daily_session/daily_session_screen.dart';
import '../../features/plan_detail/plan_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create/pick-surahs',
      builder: (context, state) => const SurahPickerScreen(),
    ),
    GoRoute(
      path: '/create/setup',
      builder: (context, state) {
        final selectedSurahs = state.extra as List<int>;
        return PlanSetupScreen(selectedSurahs: selectedSurahs);
      },
    ),
    GoRoute(
      path: '/create/preview',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return PlanPreviewScreen(
          selectedSurahs: args['surahs'] as List<int>,
          days: args['days'] as int,
          notificationTime: args['time'] as String,
        );
      },
    ),
    GoRoute(
      path: '/plan/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PlanDetailScreen(planId: id);
      },
    ),
    GoRoute(
      path: '/session/:planId/:dayIndex',
      builder: (context, state) {
        final planId = state.pathParameters['planId']!;
        final dayIndex = int.parse(state.pathParameters['dayIndex']!);
        return DailySessionScreen(planId: planId, dayIndex: dayIndex);
      },
    ),
  ],
);
