import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran/quran.dart' as quran;
import '../../core/theme/app_theme.dart';
import '../../data/models/weak_surah_model.dart';
import '../../providers/weak_surah_providers.dart';

class WeakSurahsScreen extends ConsumerStatefulWidget {
  const WeakSurahsScreen({super.key});

  @override
  ConsumerState<WeakSurahsScreen> createState() => _WeakSurahsScreenState();
}

class _WeakSurahsScreenState extends ConsumerState<WeakSurahsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSurahs = ref.watch(weakSurahsProvider);
    final settings = ref.watch(weakSurahSettingsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'السور الضعيفة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            activeSurahs.isEmpty
                                ? 'لا توجد سور مضافة'
                                : '${activeSurahs.length} سورة تحتاج مراجعة',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showSettingsSheet(context, settings),
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: AppTheme.primary, size: 26),
                          if (settings.isEnabled && activeSurahs.isNotEmpty)
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.push('/weak-surahs/add'),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.divider,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textMedium,
                    tabs: const [
                      Tab(text: 'جارية'),
                      Tab(text: 'محلولة'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (settings.isEnabled && activeSurahs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _NotifBanner(settings: settings),
                ).animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ActiveSurahsList(surahs: activeSurahs),
                    const _ResolvedSurahsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsSheet(BuildContext context, WeakSurahSettings settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NotificationSettingsSheet(settings: settings),
    );
  }
}

class _ActiveSurahsList extends ConsumerWidget {
  final List<WeakSurahEntry> surahs;
  const _ActiveSurahsList({required this.surahs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (surahs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 64, color: AppTheme.primaryLight),
            const SizedBox(height: 16),
            const Text(
              'ما فيش سور ضعيفة 🎉',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط + لإضافة سور تحتاج تقوية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: surahs.length,
      itemBuilder: (ctx, i) {
        final entry = surahs[i];
        return _WeakSurahCard(entry: entry)
            .animate()
            .fadeIn(delay: (60 * i).ms)
            .slideX(begin: 0.06, end: 0);
      },
    );
  }
}

class _WeakSurahCard extends ConsumerWidget {
  final WeakSurahEntry entry;
  const _WeakSurahCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = entry.surahNumber;
    final name = quran.getSurahNameArabic(n);
    final verses = quran.getVerseCount(n);
    final days = DateTime.now().difference(entry.addedAt).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accent.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '$n',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.accent,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$verses آية · منذ $days ${days == 1 ? "يوم" : "أيام"}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _confirmResolve(context, ref, n, name),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: const Text(
                'حفظتها ✓',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => ref.read(weakSurahsProvider.notifier).remove(n),
            child: const Icon(Icons.close, color: AppTheme.textLight, size: 20),
          ),
        ],
      ),
    );
  }

  void _confirmResolve(
      BuildContext context, WidgetRef ref, int n, String name) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'تأكيد',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
          ),
          content: Text(
            'هل أنت متأكد أنك حفظت سورة $name بشكل كامل؟',
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('لا',
                  style: TextStyle(
                      fontFamily: 'Cairo', color: AppTheme.textMedium)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ref.read(weakSurahsProvider.notifier).markResolved(n);
              },
              child: const Text('نعم، حفظتها',
                  style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolvedSurahsList extends ConsumerWidget {
  const _ResolvedSurahsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = WeakSurahRepository();
    final resolved = repo.getResolved();

    if (resolved.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 64, color: AppTheme.textLight),
            const SizedBox(height: 16),
            const Text(
              'لا توجد سور محلولة بعد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                color: AppTheme.textMedium,
              ),
            ),
          ],
        ).animate().fadeIn(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: resolved.length,
      itemBuilder: (ctx, i) {
        final e = resolved[i];
        final name = quran.getSurahNameArabic(e.surahNumber);
        final date = e.resolvedAt;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppTheme.primary, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    if (date != null)
                      Text(
                        'تم ${date.day}/${date.month}/${date.year}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (60 * i).ms);
      },
    );
  }
}

class _NotifBanner extends StatelessWidget {
  final WeakSurahSettings settings;
  const _NotifBanner({required this.settings});

  @override
  Widget build(BuildContext context) {
    String desc;
    if (settings.mode == 'interval') {
      desc =
          'كل ${settings.intervalHours} ساعات من ${settings.startHour}:00 حتى ${settings.endHour}:00';
    } else {
      desc = settings.fixedTimes.join(' · ');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active,
              color: AppTheme.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'إشعارات: $desc',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingsSheet extends ConsumerStatefulWidget {
  final WeakSurahSettings settings;
  const _NotificationSettingsSheet({required this.settings});

  @override
  ConsumerState<_NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends ConsumerState<_NotificationSettingsSheet> {
  late String _mode;
  late int _intervalHours;
  late int _startHour;
  late int _endHour;
  late List<String> _fixedTimes;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    final s = widget.settings;
    _mode = s.mode;
    _intervalHours = s.intervalHours;
    _startHour = s.startHour;
    _endHour = s.endHour;
    _fixedTimes = List.from(s.fixedTimes);
    _isEnabled = s.isEnabled;
  }

  Future<void> _save() async {
    final newSettings = WeakSurahSettings(
      mode: _mode,
      intervalHours: _intervalHours,
      fixedTimes: _fixedTimes,
      startHour: _startHour,
      endHour: _endHour,
      isEnabled: _isEnabled,
    );
    await ref.read(weakSurahSettingsProvider.notifier).update(newSettings);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _addFixedTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      builder: (ctx, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    );
    if (picked != null) {
      final timeStr =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (!_fixedTimes.contains(timeStr)) {
        setState(() {
          _fixedTimes.add(timeStr);
          _fixedTimes.sort();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.divider,
                      borderRadius: BorderRadius.circular(2),
                    )),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'إعدادات الإشعارات',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  Switch(
                    value: _isEnabled,
                    activeColor: AppTheme.primary,
                    onChanged: (v) => setState(() => _isEnabled = v),
                  ),
                ],
              ),
              if (_isEnabled) ...[
                const SizedBox(height: 20),
                const Text(
                  'نوع الإشعار',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ModeChip(
                      label: 'كل فترة',
                      icon: Icons.loop,
                      selected: _mode == 'interval',
                      onTap: () => setState(() => _mode = 'interval'),
                    ),
                    const SizedBox(width: 10),
                    _ModeChip(
                      label: 'أوقات ثابتة',
                      icon: Icons.schedule,
                      selected: _mode == 'fixed_times',
                      onTap: () => setState(() => _mode = 'fixed_times'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_mode == 'interval') ...[
                  Text(
                    'كل كم ساعة: $_intervalHours ساعة',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  Slider(
                    value: _intervalHours.toDouble(),
                    min: 1,
                    max: 12,
                    divisions: 11,
                    activeColor: AppTheme.primary,
                    label: '$_intervalHours ساعة',
                    onChanged: (v) =>
                        setState(() => _intervalHours = v.round()),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _HourPicker(
                          label: 'من الساعة',
                          value: _startHour,
                          min: 0,
                          max: 23,
                          onChanged: (v) => setState(() => _startHour = v),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _HourPicker(
                          label: 'حتى الساعة',
                          value: _endHour,
                          min: 0,
                          max: 23,
                          onChanged: (v) => setState(() => _endHour = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Builder(builder: (ctx) {
                    int count = 0;
                    int h = _startHour;
                    while (h <= _endHour) {
                      count++;
                      h += _intervalHours;
                    }
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '≈ $count إشعار يومياً',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: AppTheme.primary,
                        ),
                      ),
                    );
                  }),
                ],
                if (_mode == 'fixed_times') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الأوقات (${_fixedTimes.length})',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMedium,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addFixedTime,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('أضف وقت',
                            style:
                                TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                      ),
                    ],
                  ),
                  if (_fixedTimes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'لم تضف أي وقت بعد',
                        style: TextStyle(
                            fontFamily: 'Cairo', color: AppTheme.textLight),
                      ),
                    ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _fixedTimes
                        .map((t) => GestureDetector(
                              onTap: () =>
                                  setState(() => _fixedTimes.remove(t)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppTheme.primary.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(t,
                                        style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.primary)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.close,
                                        size: 14, color: AppTheme.primary),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text('حفظ الإعدادات',
                      style: TextStyle(fontFamily: 'Cairo')),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: selected ? AppTheme.primary : AppTheme.divider),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? Colors.white : AppTheme.textMedium,
                  size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HourPicker extends StatelessWidget {
  final String label;
  final int value;
  final int min, max;
  final ValueChanged<int> onChanged;
  const _HourPicker(
      {required this.label,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 12, color: AppTheme.textMedium)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.divider),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: value > min ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '${value.toString().padLeft(2, '0')}:00',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              IconButton(
                onPressed: value < max ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeakSurahRepository {
  List<WeakSurahEntry> getResolved() {
    return [];
  }
}
