// lib/features/create_plan/plan_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../data/repositories/plan_repository.dart';

class PlanSetupScreen extends StatefulWidget {
  final List<int> selectedSurahs;
  const PlanSetupScreen({super.key, required this.selectedSurahs});

  @override
  State<PlanSetupScreen> createState() => _PlanSetupScreenState();
}

class _PlanSetupScreenState extends State<PlanSetupScreen> {
  int _selectedDays = 7;
  TimeOfDay _notifTime = const TimeOfDay(hour: 8, minute: 0);
  final _nameController = TextEditingController();

  final _presetDays = [3, 7, 14, 21, 30];

  @override
  void initState() {
    super.initState();
    // Auto-generate plan name
    final firstSurah = quran.getSurahNameArabic(widget.selectedSurahs.first);
    final lastSurah = widget.selectedSurahs.length > 1
        ? quran.getSurahNameArabic(widget.selectedSurahs.last)
        : null;
    _nameController.text = lastSurah != null
        ? 'من $firstSurah إلى $lastSurah'
        : 'مراجعة $firstSurah';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _timeFmt {
    final h = _notifTime.hour.toString().padLeft(2, '0');
    final m = _notifTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // Preview: how many surahs per day
  String _previewLine() {
    final days = _selectedDays;
    // ignore: unused_local_variable
    final total = widget.selectedSurahs.length;
    final entries = PlanRepository.buildDayEntries(widget.selectedSurahs, days);
    final dayCounts = entries.map((e) => e.surahNumbers.length).toSet().toList()
      ..sort();
    if (dayCounts.length == 1) {
      return '${dayCounts.first} سورة يومياً';
    }
    return '${dayCounts.last} سور في بعض الأيام، ${dayCounts.first} في الباقي';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('إعداد الخطة'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected surahs summary
            _SectionCard(
              title: 'السور المختارة (${widget.selectedSurahs.length})',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.selectedSurahs.map((n) => _SurahChip(n)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Plan name
            _SectionCard(
              title: 'اسم الخطة',
              child: TextField(
                controller: _nameController,
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 15),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'أدخل اسماً للخطة',
                  hintStyle:
                      TextStyle(fontFamily: 'Cairo', color: AppTheme.textLight),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Days selection
            _SectionCard(
              title: 'عدد أيام المراجعة',
              child: Column(
                children: [
                  Wrap(
                    spacing: 10,
                    children: _presetDays
                        .map((d) => _DayChip(
                              days: d,
                              selected: _selectedDays == d,
                              onTap: () => setState(() => _selectedDays = d),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('مخصص:',
                          style: TextStyle(
                              fontFamily: 'Cairo', color: AppTheme.textMedium)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: _selectedDays.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 59,
                          activeColor: AppTheme.primary,
                          onChanged: (v) =>
                              setState(() => _selectedDays = v.round()),
                        ),
                      ),
                      Text(
                        '$_selectedDays يوم',
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppTheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _previewLine(),
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notification time
            _SectionCard(
              title: 'وقت الإشعار اليومي',
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _notifTime,
                    builder: (ctx, child) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: child!,
                    ),
                  );
                  if (picked != null) setState(() => _notifTime = picked);
                },
                child: Row(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: AppTheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      _timeFmt,
                      style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark),
                    ),
                    const Spacer(),
                    const Text('اضغط لتغيير',
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12,
                            color: AppTheme.textLight)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/create/preview', extra: {
                    'surahs': widget.selectedSurahs,
                    'days': _selectedDays,
                    'time': _timeFmt,
                    'name': _nameController.text.trim(),
                  });
                },
                child: const Text('معاينة الخطة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMedium)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final int days;
  final bool selected;
  final VoidCallback onTap;
  const _DayChip(
      {required this.days, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: selected ? AppTheme.primary : AppTheme.divider),
        ),
        child: Text(
          '$days يوم',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textMedium,
          ),
        ),
      ),
    );
  }
}

class _SurahChip extends StatelessWidget {
  final int number;
  const _SurahChip(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        quran.getSurahNameArabic(number),
        style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: AppTheme.primary,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
