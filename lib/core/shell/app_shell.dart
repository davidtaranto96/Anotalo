import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/widgets/app_fab.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:arquitectura_enfoque/features/proyectos/presentation/widgets/add_project_bottom_sheet.dart';


class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  static const _tabs = [
    _TabConfig('hoy',        Icons.today_rounded,               'Hoy'),
    _TabConfig('semana',     Icons.calendar_view_week_rounded,   'Semana'),
    _TabConfig('proyectos',  Icons.folder_rounded,               'Proyectos'),
    _TabConfig('habitos',    Icons.loop_rounded,                 'Hábitos'),
    _TabConfig('enfoque',    Icons.timer_rounded,                'Enfoque'),
  ];

  static const _fabIcons = [
    Icons.add_rounded,           // hoy
    null,                        // semana — sin FAB
    Icons.create_new_folder_rounded, // proyectos
    Icons.add_rounded,           // habitos
    Icons.play_arrow_rounded,    // enfoque
  ];

  void _onTabTap(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = navigationShell.currentIndex;
    final fabIcon = _fabIcons[currentIndex];
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.surfaceBase,
      body: navigationShell,
      floatingActionButton: fabIcon == null ? null : AppFab(
        icon: fabIcon,
        onTap: () {
          switch (currentIndex) {
            case 0: // Hoy
              AddTaskBottomSheet.show(context);
              break;
            case 2: // Proyectos
              AddProjectBottomSheet.show(context);
              break;
            default:
              break;
          }
        },
        onLongPress: () {
          // TODO: open QuickCapture bottom sheet
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: BoxDecoration(
              color: AppTheme.surfaceSheet.withAlpha((0.85 * 255).round()),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withAlpha((0.08 * 255).round()),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final selected = i == currentIndex;
                return InkWell(
                  onTap: () => _onTabTap(context, i),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            tab.icon,
                            key: ValueKey('$i-$selected'),
                            color: selected
                                ? AppTheme.colorPrimary
                                : AppTheme.colorNeutral,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppTheme.colorPrimary
                                : AppTheme.colorNeutral,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String id;
  final IconData icon;
  final String label;
  const _TabConfig(this.id, this.icon, this.label);
}
