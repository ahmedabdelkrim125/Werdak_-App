import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    '/home',
    '/weak-surahs',
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => location.startsWith(t));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: child,
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          index: idx,
          backgroundColor: Colors.transparent,
          color: AppTheme.primary,
          buttonBackgroundColor: AppTheme.primaryDark,
          height: 60,
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          onTap: (i) => context.go(_tabs[i]),
          items: const [
            ImageIcon(
              AssetImage('assets/images/صفحة خطط المراجعة.png'),
              color: Colors.white,
              size: 50,
            ),
            ImageIcon(
              AssetImage('assets/images/الصور الضعيفة.png'),
              color: Colors.white,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
