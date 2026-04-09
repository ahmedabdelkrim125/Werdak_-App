// lib/features/daily_session/daily_session_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../providers/plan_providers.dart';

class DailySessionScreen extends ConsumerStatefulWidget {
  final String planId;
  final int dayIndex;
  const DailySessionScreen(
      {super.key, required this.planId, required this.dayIndex});

  @override
  ConsumerState<DailySessionScreen> createState() => _DailySessionScreenState();
}

class _DailySessionScreenState extends ConsumerState<DailySessionScreen> {
  final Set<int> _reviewed = {}; // surah numbers reviewed so far
  bool _saving = false;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(planByIdProvider(widget.planId));
    if (plan == null)
      return const Scaffold(body: Center(child: Text('الخطة غير موجودة')));

    final dayEntry = plan.days[widget.dayIndex];
    final surahs = dayEntry.surahNumbers;
    final allReviewed = _reviewed.length == surahs.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('اليوم ${dayEntry.dayNumber}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/plan/${widget.planId}'),
        ),
      ),
      body: _done
          ? _buildDoneState(context)
          : Column(
              children: [
                // Progress header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_reviewed.length} / ${surahs.length} سور',
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppTheme.textMedium),
                          ),
                          Text(
                            'اليوم ${widget.dayIndex + 1} من ${plan.totalDays}',
                            style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppTheme.textLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: surahs.isEmpty
                              ? 1
                              : _reviewed.length / surahs.length,
                          minHeight: 8,
                          backgroundColor: AppTheme.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryLight),
                        ),
                      ),
                    ],
                  ),
                ),

                // Surah cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: surahs.length,
                    itemBuilder: (ctx, i) {
                      final n = surahs[i];
                      final checked = _reviewed.contains(n);
                      return _SurahReviewCard(
                        number: n,
                        checked: checked,
                        onTap: () => setState(() {
                          if (checked)
                            _reviewed.remove(n);
                          else
                            _reviewed.add(n);
                        }),
                      )
                          .animate()
                          .fadeIn(delay: (80 * i).ms)
                          .slideX(begin: 0.06, end: 0);
                    },
                  ),
                ),

                // Mark done button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedOpacity(
                      opacity: allReviewed ? 1.0 : 0.4,
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: allReviewed && !_saving ? _markDone : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('انتهيت من مراجعة اليوم'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _markDone() async {
    setState(() => _saving = true);
    await ref
        .read(dayCompletionProvider.notifier)
        .markComplete(widget.planId, widget.dayIndex);
    setState(() {
      _saving = false;
      _done = true;
    });
  }

  Widget _buildDoneState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: AppTheme.primary, size: 80)
              .animate()
              .scale(
                  begin: const Offset(0, 0),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: Curves.elasticOut),
          const SizedBox(height: 24),
          const Text(
            'أحسنت!',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 8),
          const Text(
            'انتهيت من مراجعة اليوم',
            style: TextStyle(
                fontFamily: 'Cairo', fontSize: 16, color: AppTheme.textMedium),
          ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => context.go('/plan/${widget.planId}'),
            child: const Text('عودة للخطة'),
          ).animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }
}

class _SurahReviewCard extends StatelessWidget {
  final int number;
  final bool checked;
  final VoidCallback onTap;
  const _SurahReviewCard(
      {required this.number, required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ayahCount = quran.getVerseCount(number);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              checked ? AppTheme.primary.withOpacity(0.07) : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: checked ? AppTheme.primary : AppTheme.divider,
            width: checked ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Surah number badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: checked
                    ? AppTheme.primary
                    : AppTheme.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: checked ? Colors.white : AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quran.getSurahNameArabic(number),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: checked ? AppTheme.primary : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$ayahCount آية',
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppTheme.textLight),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: checked
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppTheme.primary, size: 28, key: ValueKey('c'))
                  : Icon(Icons.radio_button_unchecked,
                      color: AppTheme.divider,
                      size: 28,
                      key: const ValueKey('u')),
            ),
          ],
        ),
      ),
    );
  }
}
