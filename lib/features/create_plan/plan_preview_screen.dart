// lib/features/create_plan/plan_preview_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../data/repositories/plan_repository.dart';
import '../../providers/plan_providers.dart';

class PlanPreviewScreen extends ConsumerWidget {
  final List<int> selectedSurahs;
  final int days;
  final String notificationTime;

  const PlanPreviewScreen({
    super.key,
    required this.selectedSurahs,
    required this.days,
    required this.notificationTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayEntries = PlanRepository.buildDayEntries(selectedSurahs, days);
    final createState = ref.watch(createPlanProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('معاينة الخطة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Summary header
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Stat(label: 'سور', value: '${selectedSurahs.length}'),
                _divider(),
                _Stat(label: 'أيام', value: '$days'),
                _divider(),
                _Stat(label: 'الإشعار', value: notificationTime),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

          // Day list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: dayEntries.length,
              itemBuilder: (ctx, i) {
                final entry = dayEntries[i];
                final isEmpty = entry.surahNumbers.isEmpty;
                return _DayRow(
                  dayNumber: entry.dayNumber,
                  surahNumbers: entry.surahNumbers,
                  isEmpty: isEmpty,
                )
                    .animate()
                    .fadeIn(delay: (60 * i).ms)
                    .slideX(begin: 0.08, end: 0);
              },
            ),
          ),

          // Save button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: createState.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        final plan =
                            await ref.read(createPlanProvider.notifier).create(
                                  name: 'مراجعة جديدة',
                                  surahNumbers: selectedSurahs,
                                  days: days,
                                  notificationTime: notificationTime,
                                );
                        if (plan != null && context.mounted) {
                          context.go('/home');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: const Text('احفظ الخطة وابدأ'),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 32, color: Colors.white.withOpacity(0.3));
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        Text(label,
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Colors.white.withOpacity(0.75))),
      ],
    );
  }
}

class _DayRow extends StatelessWidget {
  final int dayNumber;
  final List<int> surahNumbers;
  final bool isEmpty;
  const _DayRow(
      {required this.dayNumber,
      required this.surahNumbers,
      required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isEmpty
                ? AppTheme.divider
                : AppTheme.primaryLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEmpty
                  ? AppTheme.divider
                  : AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              '$dayNumber',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: isEmpty ? AppTheme.textLight : AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: isEmpty
                ? const Text('مراجعة حرة',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppTheme.textLight,
                        fontSize: 14))
                : Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: surahNumbers
                        .map((n) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                quran.getSurahNameArabic(n),
                                style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
