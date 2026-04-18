// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quran/quran.dart' as quran;
// import '../../core/theme/app_theme.dart';
// import '../../providers/weak_surah_providers.dart';

// class AddWeakSurahScreen extends ConsumerStatefulWidget {
//   const AddWeakSurahScreen({super.key});

//   @override
//   ConsumerState<AddWeakSurahScreen> createState() => _AddWeakSurahScreenState();
// }

// class _AddWeakSurahScreenState extends ConsumerState<AddWeakSurahScreen> {
//   final Set<int> _selected = {};
//   final TextEditingController _search = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _search.dispose();
//     super.dispose();
//   }

//   List<int> get _filteredSurahs {
//     final all = List.generate(114, (i) => i + 1);
//     if (_query.isEmpty) return all;
//     return all.where((n) {
//       final name = quran.getSurahNameArabic(n);
//       return name.contains(_query) || '$n'.contains(_query);
//     }).toList();
//   }

//   Future<void> _addSelected() async {
//     final notifier = ref.read(weakSurahsProvider.notifier);
//     for (final n in _selected) {
//       if (!notifier.isTracked(n)) {
//         await notifier.add(n);
//       }
//     }
//     if (mounted) context.pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tracked =
//         ref.watch(weakSurahsProvider).map((e) => e.surahNumber).toSet();
//     final filtered = _filteredSurahs;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: AppTheme.background,
//         appBar: AppBar(
//           title: const Text('أضف سوراً ضعيفة'),
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             onPressed: () => context.pop(),
//           ),
//           actions: [
//             if (_selected.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: TextButton(
//                   onPressed: _addSelected,
//                   child: Text(
//                     'أضف (${_selected.length})',
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       fontWeight: FontWeight.w700,
//                       color: AppTheme.accent,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
//               child: TextField(
//                 controller: _search,
//                 onChanged: (v) => setState(() => _query = v),
//                 textAlign: TextAlign.right,
//                 style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
//                 decoration: InputDecoration(
//                   hintText: 'ابحث عن سورة...',
//                   hintStyle: const TextStyle(
//                       fontFamily: 'Cairo', color: AppTheme.textLight),
//                   prefixIcon:
//                       const Icon(Icons.search, color: AppTheme.textLight),
//                   filled: true,
//                   fillColor: AppTheme.surface,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: const BorderSide(color: AppTheme.divider),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: const BorderSide(color: AppTheme.divider),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide:
//                         const BorderSide(color: AppTheme.primary, width: 1.5),
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//               ),
//             ).animate().fadeIn(duration: 300.ms),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 itemCount: filtered.length,
//                 itemBuilder: (ctx, i) {
//                   final n = filtered[i];
//                   final isSelected = _selected.contains(n);
//                   final isTracked = tracked.contains(n);

//                   return GestureDetector(
//                     onTap: isTracked
//                         ? null
//                         : () => setState(() {
//                               if (isSelected)
//                                 _selected.remove(n);
//                               else
//                                 _selected.add(n);
//                             }),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       margin: const EdgeInsets.only(bottom: 8),
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: isTracked
//                             ? AppTheme.divider.withOpacity(0.4)
//                             : isSelected
//                                 ? AppTheme.accent.withOpacity(0.08)
//                                 : AppTheme.surface,
//                         borderRadius: BorderRadius.circular(14),
//                         border: Border.all(
//                           color:
//                               isSelected ? AppTheme.accent : AppTheme.divider,
//                           width: isSelected ? 1.5 : 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               color: isTracked
//                                   ? AppTheme.divider
//                                   : isSelected
//                                       ? AppTheme.accent
//                                       : AppTheme.accent.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             alignment: Alignment.center,
//                             child: Text(
//                               '$n',
//                               style: TextStyle(
//                                 fontFamily: 'Cairo',
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w700,
//                                 color: isSelected
//                                     ? Colors.white
//                                     : isTracked
//                                         ? AppTheme.textLight
//                                         : AppTheme.accent,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 14),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   quran.getSurahNameArabic(n),
//                                   style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                     color: isTracked
//                                         ? AppTheme.textLight
//                                         : AppTheme.textDark,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${quran.getVerseCount(n)} آية',
//                                   style: const TextStyle(
//                                     fontFamily: 'Cairo',
//                                     fontSize: 12,
//                                     color: AppTheme.textLight,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (isTracked)
//                             const Text('مضافة',
//                                 style: TextStyle(
//                                     fontFamily: 'Cairo',
//                                     fontSize: 12,
//                                     color: AppTheme.textLight))
//                           else
//                             AnimatedSwitcher(
//                               duration: const Duration(milliseconds: 200),
//                               child: isSelected
//                                   ? const Icon(Icons.check_circle_rounded,
//                                       color: AppTheme.accent,
//                                       size: 26,
//                                       key: ValueKey('s'))
//                                   : Icon(Icons.radio_button_unchecked,
//                                       color: AppTheme.divider,
//                                       size: 26,
//                                       key: const ValueKey('u')),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ).animate().fadeIn(delay: (30 * i).ms);
//                 },
//               ),
//             ),
//             if (_selected.isNotEmpty)
//               SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: ElevatedButton(
//                     onPressed: _addSelected,
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 54),
//                       backgroundColor: AppTheme.accent,
//                     ),
//                     child: Text(
//                       'أضف ${_selected.length} سورة للمراجعة',
//                       style: const TextStyle(fontFamily: 'Cairo', fontSize: 16),
//                     ),
//                   ),
//                 ),
//               ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../providers/weak_surah_providers.dart';

class AddWeakSurahScreen extends ConsumerStatefulWidget {
  const AddWeakSurahScreen({super.key});

  @override
  ConsumerState<AddWeakSurahScreen> createState() => _AddWeakSurahScreenState();
}

class _AddWeakSurahScreenState extends ConsumerState<AddWeakSurahScreen> {
  final Set<int> _selected = {};
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<int> get _filteredSurahs {
    final all = List.generate(114, (i) => i + 1);
    if (_query.isEmpty) return all;
    return all.where((n) {
      final name = quran.getSurahNameArabic(n);
      return name.contains(_query) || '$n'.contains(_query);
    }).toList();
  }

  Future<void> _addSelected() async {
    final notifier = ref.read(weakSurahsProvider.notifier);
    for (final n in _selected) {
      if (!notifier.isTracked(n)) {
        await notifier.add(n);
      }
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final tracked =
        ref.watch(weakSurahsProvider).map((e) => e.surahNumber).toSet();
    final filtered = _filteredSurahs;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('أضف سوراً ضعيفة'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (_selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: _addSelected,
                  child: Text(
                    'أضف (${_selected.length})',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accent,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                controller: _search,
                onChanged: (v) => setState(() => _query = v),
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'ابحث عن سورة...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Cairo', color: AppTheme.textLight),
                  prefixIcon:
                      const Icon(Icons.search, color: AppTheme.textLight),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppTheme.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final n = filtered[i];
                  final isSelected = _selected.contains(n);
                  final isTracked = tracked.contains(n);

                  return GestureDetector(
                    onTap: isTracked
                        ? null
                        : () => setState(() {
                              if (isSelected) {
                                _selected.remove(n);
                              } else {
                                _selected.add(n);
                              }
                            }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isTracked
                            ? AppTheme.divider.withOpacity(0.4)
                            : isSelected
                                ? AppTheme.accent.withOpacity(0.08)
                                : AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              isSelected ? AppTheme.accent : AppTheme.divider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isTracked
                                  ? AppTheme.divider
                                  : isSelected
                                      ? AppTheme.accent
                                      : AppTheme.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$n',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? Colors.white
                                    : isTracked
                                        ? AppTheme.textLight
                                        : AppTheme.accent,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quran.getSurahNameArabic(n),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: isTracked
                                        ? AppTheme.textLight
                                        : AppTheme.textDark,
                                  ),
                                ),
                                Text(
                                  '${quran.getVerseCount(n)} آية',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: AppTheme.textLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isTracked)
                            const Text('مضافة',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 12,
                                    color: AppTheme.textLight))
                          else
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: isSelected
                                  ? const Icon(Icons.check_circle_rounded,
                                      color: AppTheme.accent,
                                      size: 26,
                                      key: ValueKey('s'))
                                  : const Icon(Icons.radio_button_unchecked,
                                      color: AppTheme.divider,
                                      size: 26,
                                      key: ValueKey('u')),
                            ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: (30 * i).ms);
                },
              ),
            ),
            if (_selected.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  onPressed: _addSelected,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 54),
                    backgroundColor: AppTheme.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'أضف ${_selected.length} سورة للمراجعة',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
