// // lib/features/plan_detail/plan_detail_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quran/quran.dart' as quran;
// import '../../core/theme/app_theme.dart';
// import '../../data/models/plan_model.dart';
// import '../../providers/plan_providers.dart';

// class PlanDetailScreen extends ConsumerWidget {
//   final String planId;
//   const PlanDetailScreen({super.key, required this.planId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final plan = ref.watch(planByIdProvider(planId));
//     if (plan == null) {
//       return const Scaffold(body: Center(child: Text('الخطة غير موجودة')));
//     }

//     final todayIdx = plan.todayIndex;

//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         title: Text(plan.name),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => context.go('/home'),
//         ),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           // Progress card
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: _ProgressCard(plan: plan),
//             ),
//           ),

//           // Today's session button
//           if (todayIdx != null && !plan.days[todayIdx].isCompleted)
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: ElevatedButton.icon(
//                   onPressed: () => context.go('/session/$planId/$todayIdx'),
//                   icon: const Icon(Icons.play_arrow_rounded),
//                   label: const Text('ابدأ مراجعة اليوم'),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(double.infinity, 52),
//                     backgroundColor: AppTheme.accent,
//                   ),
//                 ),
//               ),
//             ),

//           const SliverToBoxAdapter(child: SizedBox(height: 16)),

//           // Day timeline
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (ctx, i) {
//                 final entry = plan.days[i];
//                 final isToday = i == todayIdx;
//                 final isPast = i < (todayIdx ?? 0);
//                 return _TimelineRow(
//                   entry: entry,
//                   isToday: isToday,
//                   isPast: isPast,
//                   isLast: i == plan.days.length - 1,
//                   onTap: isToday && !entry.isCompleted
//                       ? () => context.go('/session/$planId/$i')
//                       : null,
//                 );
//               },
//               childCount: plan.days.length,
//             ),
//           ),
//           const SliverToBoxAdapter(child: SizedBox(height: 40)),
//         ],
//       ),
//     );
//   }
// }

// class _ProgressCard extends StatelessWidget {
//   final PlanModel plan;
//   const _ProgressCard({required this.plan});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppTheme.surface,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppTheme.divider),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '${plan.completedDays} / ${plan.totalDays} أيام',
//                 style: const TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: AppTheme.textDark),
//               ),
//               Text(
//                 '${(plan.progress * 100).round()}%',
//                 style: const TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: AppTheme.primary),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: LinearProgressIndicator(
//               value: plan.progress,
//               minHeight: 10,
//               backgroundColor: AppTheme.divider,
//               valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _Stat(label: 'بدأت', value: _formatDate(plan.startDate)),
//               _Stat(label: 'الإشعار', value: plan.notificationTime),
//               _Stat(label: 'السور', value: '${plan.surahNumbers.length}'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
// }

// class _Stat extends StatelessWidget {
//   final String label, value;
//   const _Stat({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(value,
//             style: const TextStyle(
//                 fontFamily: 'Cairo',
//                 fontSize: 15,
//                 fontWeight: FontWeight.w700,
//                 color: AppTheme.textDark)),
//         Text(label,
//             style: const TextStyle(
//                 fontFamily: 'Cairo', fontSize: 12, color: AppTheme.textLight)),
//       ],
//     );
//   }
// }

// class _TimelineRow extends StatelessWidget {
//   final DayEntry entry;
//   final bool isToday, isPast, isLast;
//   final VoidCallback? onTap;
//   const _TimelineRow(
//       {required this.entry,
//       required this.isToday,
//       required this.isPast,
//       required this.isLast,
//       this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final isEmpty = entry.surahNumbers.isEmpty;
//     Color dotColor = AppTheme.divider;
//     if (entry.isCompleted) dotColor = AppTheme.primary;
//     if (isToday && !entry.isCompleted) dotColor = AppTheme.accent;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Timeline dot + line
//           Column(
//             children: [
//               Container(
//                 width: 14,
//                 height: 14,
//                 margin: const EdgeInsets.only(top: 16),
//                 decoration: BoxDecoration(
//                   color: dotColor,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: dotColor, width: 2),
//                 ),
//                 child: entry.isCompleted
//                     ? const Icon(Icons.check, size: 10, color: Colors.white)
//                     : null,
//               ),
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 50,
//                   color: isPast || entry.isCompleted
//                       ? AppTheme.primary.withOpacity(0.3)
//                       : AppTheme.divider,
//                 ),
//             ],
//           ),
//           const SizedBox(width: 14),

//           // Content
//           Expanded(
//             child: GestureDetector(
//               onTap: onTap,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: const EdgeInsets.only(bottom: 8),
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: isToday && !entry.isCompleted
//                       ? AppTheme.accent.withOpacity(0.07)
//                       : AppTheme.surface,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(
//                     color: isToday && !entry.isCompleted
//                         ? AppTheme.accent.withOpacity(0.4)
//                         : AppTheme.divider,
//                     width: isToday ? 1.5 : 1,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'اليوم ${entry.dayNumber}${isToday ? " · اليوم" : ""}',
//                             style: TextStyle(
//                               fontFamily: 'Cairo',
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: isToday
//                                   ? AppTheme.accent
//                                   : AppTheme.textMedium,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           isEmpty
//                               ? const Text('مراجعة حرة',
//                                   style: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       fontSize: 13,
//                                       color: AppTheme.textLight))
//                               : Text(
//                                   entry.surahNumbers
//                                       .map((n) => quran.getSurahNameArabic(n))
//                                       .join(' · '),
//                                   style: const TextStyle(
//                                       fontFamily: 'Cairo',
//                                       fontSize: 14,
//                                       color: AppTheme.textDark),
//                                 ),
//                         ],
//                       ),
//                     ),
//                     if (entry.isCompleted)
//                       const Icon(Icons.check_circle,
//                           color: AppTheme.primary, size: 22),
//                     if (onTap != null)
//                       const Icon(Icons.chevron_right, color: AppTheme.accent),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/features/plan_detail/plan_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../data/models/plan_model.dart';
import '../../providers/plan_providers.dart';

class PlanDetailScreen extends ConsumerWidget {
  final String planId;
  const PlanDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planByIdProvider(planId));
    if (plan == null) {
      return const Scaffold(body: Center(child: Text('الخطة غير موجودة')));
    }

    final todayIdx = plan.todayIndex;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(plan.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Progress card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _ProgressCard(plan: plan),
            ),
          ),

          // Today's session button
          if (todayIdx != null && !plan.days[todayIdx].isCompleted)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/session/$planId/$todayIdx'),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('ابدأ مراجعة اليوم'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: AppTheme.accent,
                  ),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Day timeline
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final entry = plan.days[i];
                final isToday = i == todayIdx;
                final isPast = i < (todayIdx ?? 0);

                // ✅ كل الأيام قابلة للضغط — مش بس اليوم الحالي
                final onTap = !entry.isCompleted
                    ? () => context.go('/session/$planId/$i')
                    : null;

                return _TimelineRow(
                  entry: entry,
                  isToday: isToday,
                  isPast: isPast,
                  isLast: i == plan.days.length - 1,
                  onTap: onTap,
                );
              },
              childCount: plan.days.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final PlanModel plan;
  const _ProgressCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${plan.completedDays} / ${plan.totalDays} أيام',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark),
              ),
              Text(
                '${(plan.progress * 100).round()}%',
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: plan.progress,
              minHeight: 10,
              backgroundColor: AppTheme.divider,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(label: 'بدأت', value: _formatDate(plan.startDate)),
              _Stat(label: 'الإشعار', value: plan.notificationTime),
              _Stat(label: 'السور', value: '${plan.surahNumbers.length}'),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
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
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark)),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 12, color: AppTheme.textLight)),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final DayEntry entry;
  final bool isToday, isPast, isLast;
  final VoidCallback? onTap;
  const _TimelineRow(
      {required this.entry,
      required this.isToday,
      required this.isPast,
      required this.isLast,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEmpty = entry.surahNumbers.isEmpty;
    Color dotColor = AppTheme.divider;
    if (entry.isCompleted) dotColor = AppTheme.primary;
    if (isToday && !entry.isCompleted) dotColor = AppTheme.accent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot + line
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: entry.isCompleted
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 50,
                  color: isPast || entry.isCompleted
                      ? AppTheme.primary.withOpacity(0.3)
                      : AppTheme.divider,
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isToday && !entry.isCompleted
                      ? AppTheme.accent.withOpacity(0.07)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isToday && !entry.isCompleted
                        ? AppTheme.accent.withOpacity(0.4)
                        : AppTheme.divider,
                    width: isToday ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اليوم ${entry.dayNumber}${isToday ? " · اليوم" : ""}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isToday
                                  ? AppTheme.accent
                                  : AppTheme.textMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          isEmpty
                              ? const Text('مراجعة حرة',
                                  style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      color: AppTheme.textLight))
                              : Text(
                                  entry.surahNumbers
                                      .map((n) => quran.getSurahNameArabic(n))
                                      .join(' · '),
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      color: AppTheme.textDark),
                                ),
                        ],
                      ),
                    ),
                    if (entry.isCompleted)
                      const Icon(Icons.check_circle,
                          color: AppTheme.primary, size: 22),
                    // ✅ سهم الدخول يبان لكل يوم لسه ما اتعملش
                    if (onTap != null)
                      const Icon(Icons.chevron_right, color: AppTheme.accent),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}