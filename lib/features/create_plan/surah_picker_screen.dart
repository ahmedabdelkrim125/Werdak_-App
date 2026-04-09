// // lib/features/create_plan/surah_picker_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:go_router/go_router.dart';
// import 'package:quran/quran.dart' as quran;
// import '../../core/theme/app_theme.dart';

// class SurahPickerScreen extends StatefulWidget {
//   const SurahPickerScreen({super.key});

//   @override
//   State<SurahPickerScreen> createState() => _SurahPickerScreenState();
// }

// class _SurahPickerScreenState extends State<SurahPickerScreen> {
//   final Set<int> _selected = {};
//   final _search = TextEditingController();
//   String _query = '';

//   @override
//   void dispose() {
//     _search.dispose();
//     super.dispose();
//   }

//   List<int> get _filteredSurahs {
//     return List.generate(114, (i) => i + 1).where((n) {
//       if (_query.isEmpty) return true;
//       final name = quran.getSurahNameArabic(n);
//       return name.contains(_query);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filtered = _filteredSurahs;
//     return Scaffold(
//       backgroundColor: AppTheme.background,
//       appBar: AppBar(
//         title: const Text('اختر السور'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => context.pop(),
//         ),
//         actions: [
//           if (_selected.isNotEmpty)
//             TextButton(
//               onPressed: () => context.go(
//                 '/create/setup',
//                 extra: _selected.toList()..sort(),
//               ),
//               child: Text(
//                 'التالي (${_selected.length})',
//                 style: const TextStyle(
//                   fontFamily: 'Cairo',
//                   color: AppTheme.primary,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//             child: TextField(
//               controller: _search,
//               textAlign: TextAlign.right,
//               decoration: InputDecoration(
//                 hintText: 'ابحث عن سورة...',
//                 hintStyle: const TextStyle(
//                   fontFamily: 'Cairo',
//                   color: AppTheme.textLight,
//                 ),
//                 prefixIcon: const Icon(Icons.search, color: AppTheme.textLight),
//                 filled: true,
//                 fillColor: AppTheme.surface,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: AppTheme.divider),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(color: AppTheme.divider),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(14),
//                   borderSide: const BorderSide(
//                     color: AppTheme.primary,
//                     width: 1.5,
//                   ),
//                 ),
//               ),
//               onChanged: (v) => setState(() => _query = v),
//             ),
//           ),

//           // Selected count chip
//           if (_selected.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppTheme.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${_selected.length} سور مختارة',
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 13,
//                       color: AppTheme.primary,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ).animate().fadeIn(duration: 200.ms),

//           // Surah list
//           Expanded(
//             child: ListView.builder(
//               itemCount: filtered.length,
//               itemBuilder: (ctx, i) {
//                 final n = filtered[i];
//                 final isSelected = _selected.contains(n);
//                 return _SurahTile(
//                   number: n,
//                   isSelected: isSelected,
//                   onTap: () => setState(() {
//                     if (isSelected)
//                       _selected.remove(n);
//                     else
//                       _selected.add(n);
//                   }),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: _selected.isNotEmpty
//           ? SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: ElevatedButton(
//                   onPressed: () => context.go(
//                     '/create/setup',
//                     extra: _selected.toList()..sort(),
//                   ),
//                   child: Text('التالي · ${_selected.length} سور'),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }

// class _SurahTile extends StatelessWidget {
//   final int number;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _SurahTile({
//     required this.number,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final nameAr = quran.getSurahNameArabic(number);
//     final nameEn = quran.getSurahName(number);
//     final ayahCount = quran.getVerseCount(number);

//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? AppTheme.primary.withOpacity(0.08)
//               : AppTheme.surface,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected ? AppTheme.primary : AppTheme.divider,
//             width: isSelected ? 1.5 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             // Number badge
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? AppTheme.primary
//                     : AppTheme.primaryLight.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 '$number',
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: isSelected ? Colors.white : AppTheme.primary,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     nameAr,
//                     style: TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected ? AppTheme.primary : AppTheme.textDark,
//                     ),
//                   ),
//                   Text(
//                     '$nameEn · $ayahCount آية',
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 12,
//                       color: AppTheme.textLight,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),
//               child: isSelected
//                   ? const Icon(
//                       Icons.check_circle,
//                       color: AppTheme.primary,
//                       key: ValueKey('checked'),
//                     )
//                   : Icon(
//                       Icons.circle_outlined,
//                       color: AppTheme.divider,
//                       key: const ValueKey('unchecked'),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';

class SurahPickerScreen extends StatefulWidget {
  const SurahPickerScreen({super.key});

  @override
  State<SurahPickerScreen> createState() => _SurahPickerScreenState();
}

class _SurahPickerScreenState extends State<SurahPickerScreen> {
  final Set<int> _selected = {};
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<int> get _filteredSurahs {
    return List.generate(114, (i) => i + 1).where((n) {
      if (_query.isEmpty) return true;
      final name = quran.getSurahNameArabic(n);
      return name.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSurahs;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('اختر السور'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          actions: [
            if (_selected.isNotEmpty)
              TextButton(
                onPressed: () => context.go(
                  '/create/setup',
                  extra: _selected.toList()..sort(),
                ),
                child: Text(
                  'التالي (${_selected.length})',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                controller: _search,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'ابحث عن سورة...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppTheme.textLight,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.textLight,
                  ),
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
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            if (_selected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selected.length} سور مختارة',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 200.ms),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (ctx, i) {
                  final n = filtered[i];
                  final isSelected = _selected.contains(n);
                  return _SurahTile(
                    number: n,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      if (isSelected) {
                        _selected.remove(n);
                      } else {
                        _selected.add(n);
                      }
                    }),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: _selected.isNotEmpty
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () => context.go(
                      '/create/setup',
                      extra: _selected.toList()..sort(),
                    ),
                    child: Text('التالي · ${_selected.length} سور'),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const _SurahTile({
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nameAr = quran.getSurahNameArabic(number);
    final nameEn = quran.getSurahName(number);
    final ayahCount = quran.getVerseCount(number);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.08)
              : AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.primaryLight.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '$number',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameAr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primary : AppTheme.textDark,
                    ),
                  ),
                  Text(
                    '$nameEn · $ayahCount آية',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                      key: ValueKey('checked'),
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: AppTheme.divider,
                      key: const ValueKey('unchecked'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
