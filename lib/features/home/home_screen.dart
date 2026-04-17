// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quran/quran.dart' as quran;
// import '../../core/theme/app_theme.dart';
// import '../../data/models/plan_model.dart';
// import '../../providers/plan_providers.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final plans = ref.watch(allPlansProvider);
//     final activePlans = plans.where((p) => !p.isCompleted).toList();
//     final completedPlans = plans.where((p) => p.isCompleted).toList();

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppTheme.background,
//         body: SafeArea(
//           child: CustomScrollView(
//             slivers: [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               _greeting(),
//                               style: const TextStyle(
//                                 fontFamily: 'Cairo',
//                                 fontSize: 14,
//                                 color: AppTheme.textLight,
//                               ),
//                             ),
//                             const Text(
//                               'خططك',
//                               style: TextStyle(
//                                 fontFamily: 'Cairo',
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppTheme.textDark,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ).animate().fadeIn(duration: 400.ms),
//               ),
//               if (activePlans.isEmpty && completedPlans.isEmpty)
//                 SliverFillRemaining(child: _buildEmpty(context))
//               else ...[
//                 if (activePlans.isNotEmpty) ...[
//                   _sectionHeader('جارية'),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (ctx, i) => _PlanCard(plan: activePlans[i])
//                           .animate()
//                           .fadeIn(delay: (100 * i).ms)
//                           .slideX(begin: -0.1, end: 0),
//                       childCount: activePlans.length,
//                     ),
//                   ),
//                 ],
//                 if (completedPlans.isNotEmpty) ...[
//                   _sectionHeader('مكتملة'),
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (ctx, i) =>
//                           _PlanCard(plan: completedPlans[i], done: true),
//                       childCount: completedPlans.length,
//                     ),
//                   ),
//                 ],
//                 const SliverToBoxAdapter(child: SizedBox(height: 100)),
//               ],
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () => context.go('/create/pick-surahs'),
//           backgroundColor: AppTheme.primary,
//           foregroundColor: Colors.white,
//           icon: const Icon(Icons.add),
//           label: const Text(
//             'خطة جديدة',
//             style: TextStyle(
//               fontFamily: 'Cairo',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ).animate().scale(
//               delay: 600.ms,
//               duration: 400.ms,
//               curve: Curves.elasticOut,
//             ),
//       ),
//     );
//   }

//   Widget _buildEmpty(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.menu_book_outlined,
//             size: 80,
//             color: AppTheme.textLight,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'لا توجد خطط بعد',
//             style: TextStyle(
//               fontFamily: 'Cairo',
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//               color: AppTheme.textDark,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'أضف خطة مراجعة جديدة',
//             style: TextStyle(
//               fontFamily: 'Cairo',
//               fontSize: 14,
//               color: AppTheme.textLight,
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () => context.go('/create/pick-surahs'),
//             icon: const Icon(Icons.add),
//             label: const Text('ابدأ الآن'),
//           ),
//         ],
//       ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
//     );
//   }

//   SliverToBoxAdapter _sectionHeader(String title) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
//         child: Text(
//           title,
//           style: const TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: AppTheme.textMedium,
//           ),
//         ),
//       ),
//     );
//   }

//   String _greeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return 'صباح الخير';
//     if (hour < 17) return 'مساء الخير';
//     return 'مساء النور';
//   }
// }

// class _PlanCard extends ConsumerWidget {
//   final PlanModel plan;
//   final bool done;
//   const _PlanCard({required this.plan, this.done = false});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final surahNames = plan.surahNumbers
//         .take(3)
//         .map((n) => quran.getSurahNameArabic(n))
//         .join(' · ');
//     final extra =
//         plan.surahNumbers.length > 3 ? ' +${plan.surahNumbers.length - 3}' : '';

//     final todayIdx = plan.todayIndex;
//     final hasSession = todayIdx != null && !plan.days[todayIdx].isCompleted;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//       child: GestureDetector(
//         onTap: () => context.go('/plan/${plan.id}'),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: AppTheme.cardBg,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: done
//                   ? AppTheme.divider
//                   : AppTheme.primaryLight.withOpacity(0.3),
//               width: 1.5,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       plan.name,
//                       style: const TextStyle(
//                         fontFamily: 'Cairo',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: AppTheme.textDark,
//                       ),
//                     ),
//                   ),
//                   if (done)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppTheme.primaryLight.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'مكتملة',
//                         style: TextStyle(
//                           fontFamily: 'Cairo',
//                           fontSize: 12,
//                           color: AppTheme.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   if (hasSession)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppTheme.accent.withOpacity(0.15),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const Text(
//                         'اليوم',
//                         style: TextStyle(
//                           fontFamily: 'Cairo',
//                           fontSize: 12,
//                           color: AppTheme.accent,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '$surahNames$extra',
//                 style: const TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 13,
//                   color: AppTheme.textMedium,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: LinearProgressIndicator(
//                   value: plan.progress,
//                   minHeight: 6,
//                   backgroundColor: AppTheme.divider,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     done ? AppTheme.primaryLight : AppTheme.primary,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${plan.completedDays} من ${plan.totalDays} أيام',
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 12,
//                       color: AppTheme.textLight,
//                     ),
//                   ),
//                   Text(
//                     '${(plan.progress * 100).round()}%',
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color: AppTheme.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../data/models/plan_model.dart';
import '../../providers/plan_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plans = ref.watch(allPlansProvider);
    final activePlans = plans.where((p) => !p.isCompleted).toList();
    final completedPlans = plans.where((p) => p.isCompleted).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting(),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: AppTheme.textLight,
                              ),
                            ),
                            const Text(
                              'خططك',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),
              if (activePlans.isEmpty && completedPlans.isEmpty)
                SliverFillRemaining(child: _buildEmpty(context))
              else ...[
                if (activePlans.isNotEmpty) ...[
                  _sectionHeader('جارية'),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _PlanCard(plan: activePlans[i])
                          .animate()
                          .fadeIn(delay: (100 * i).ms)
                          .slideX(begin: -0.1, end: 0),
                      childCount: activePlans.length,
                    ),
                  ),
                ],
                if (completedPlans.isNotEmpty) ...[
                  _sectionHeader('مكتملة'),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) =>
                          _PlanCard(plan: completedPlans[i], done: true),
                      childCount: completedPlans.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton.extended(
            onPressed: () => context.go('/create/pick-surahs'),
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text(
              'خطة جديدة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ).animate().scale(
                delay: 600.ms,
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد خطط بعد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف خطة مراجعة جديدة',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/create/pick-surahs'),
            icon: const Icon(Icons.add),
            label: const Text('ابدأ الآن'),
          ),
        ],
      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  SliverToBoxAdapter _sectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMedium,
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'مساء الخير';
    return 'مساء النور';
  }
}

class _PlanCard extends ConsumerWidget {
  final PlanModel plan;
  final bool done;
  const _PlanCard({required this.plan, this.done = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahNames = plan.surahNumbers
        .take(3)
        .map((n) => quran.getSurahNameArabic(n))
        .join(' · ');
    final extra =
        plan.surahNumbers.length > 3 ? ' +${plan.surahNumbers.length - 3}' : '';

    final todayIdx = plan.todayIndex;
    final hasSession = todayIdx != null && !plan.days[todayIdx].isCompleted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: () => context.go('/plan/${plan.id}'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: done
                  ? AppTheme.divider
                  : AppTheme.primaryLight.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                  if (done)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'مكتملة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (hasSession)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'اليوم',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$surahNames$extra',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: AppTheme.textMedium,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: plan.progress,
                  minHeight: 6,
                  backgroundColor: AppTheme.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    done ? AppTheme.primaryLight : AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${plan.completedDays} من ${plan.totalDays} أيام',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                  Text(
                    '${(plan.progress * 100).round()}%',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}