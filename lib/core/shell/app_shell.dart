import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:arquitectura_enfoque/core/feedback/feedback_service.dart';
import 'package:arquitectura_enfoque/core/logic/auth_service.dart';
import 'package:arquitectura_enfoque/core/logic/drive_backup_service.dart';
import 'package:arquitectura_enfoque/core/logic/user_prefs.dart';
import 'package:arquitectura_enfoque/core/providers/backup_provider.dart';
import 'package:arquitectura_enfoque/core/providers/shell_providers.dart';
import 'package:arquitectura_enfoque/core/utils/format_utils.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/providers/task_provider.dart';
import 'package:arquitectura_enfoque/core/theme/anotalo_tokens.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/widgets/app_fab.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/pages/hoy_page.dart';
import 'package:arquitectura_enfoque/features/mes/presentation/pages/mes_page.dart';
import 'package:arquitectura_enfoque/features/proyectos/presentation/pages/proyectos_page.dart';
import 'package:arquitectura_enfoque/features/habitos/presentation/pages/habitos_page.dart';
import 'package:arquitectura_enfoque/features/enfoque/presentation/pages/enfoque_page.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/widgets/add_task_bottom_sheet.dart';
import 'package:arquitectura_enfoque/features/proyectos/presentation/widgets/add_project_bottom_sheet.dart';
import 'package:arquitectura_enfoque/features/habitos/presentation/widgets/add_habit_bottom_sheet.dart';
import 'package:arquitectura_enfoque/features/inbox/presentation/widgets/quick_capture_bottom_sheet.dart';
import 'package:arquitectura_enfoque/features/enfoque/presentation/providers/timer_provider.dart';
import 'package:arquitectura_enfoque/features/enfoque/domain/models/timer_state.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  late final PageController _pageController;
  int _currentPage = 0;
  /// Recordamos qué día era la última vez que la app estuvo en foreground.
  /// Si al volver el día cambió (o al pasar de medianoche con la app
  /// abierta), invalidamos los providers que dependen de `todayId()`.
  String _lastSeenDay = todayId();

  // Tabs del shell: Hoy / Calendario (mes+semana fusionados) /
  // Proyectos / Hábitos / Enfoque. La tab "Semana" fue absorbida por
  // "Calendario" — el mismo widget muestra mes o semana según el
  // formato (toggle por swipe vertical).
  static const _tabs = [
    _TabConfig(LucideIcons.calendar,         'Hoy'),
    _TabConfig(LucideIcons.calendarDays,     'Calendario'),
    _TabConfig(LucideIcons.folder,           'Proyectos'),
    _TabConfig(LucideIcons.repeat,           'Hábitos'),
    _TabConfig(LucideIcons.timer,            'Enfoque'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  /// Auto-backup al pasar a background + refresh de "hoy" al volver.
  /// - paused: si autoBackupToDrive está ON y hay sesión, sube backup.
  /// - resumed: si el día cambió desde la última vez que la app estuvo
  ///   activa (típico cruzar medianoche con la app abierta o reabrir
  ///   al día siguiente), invalidamos los providers que cachearon
  ///   `todayId()` para que se rerunran con el nuevo día.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final now = todayId();
      if (now != _lastSeenDay) {
        _lastSeenDay = now;
        // Invalidar todos los providers que dependen de "hoy" para que
        // arranquen un stream nuevo apuntando al nuevo dayId.
        ref.invalidate(todayTasksProvider);
        ref.invalidate(streakProvider);
      }
      return;
    }
    if (state != AppLifecycleState.paused) return;
    final auto = ref.read(userPrefsProvider).autoBackupToDrive;
    if (!auto) return;
    if (AuthService.instance.currentUser == null) return;
    final svc = DriveBackupService.instance(ref.read(backupServiceProvider));
    // ignore: discarded_futures
    svc.uploadBackup();
  }

  void _goToPage(int index) {
    FeedbackService.instance.tick();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Tabs: 0=Hoy, 1=Calendario, 2=Proyectos, 3=Hábitos, 4=Enfoque
    IconData? fabIcon;
    switch (_currentPage) {
      case 0:
        fabIcon = Icons.add_rounded; // Hoy — nueva tarea
      case 1:
        fabIcon = null; // Calendario — botón "Nueva tarea" inline propio
      case 2:
        fabIcon = Icons.create_new_folder_rounded; // Proyectos
      case 3:
        fabIcon = Icons.add_rounded; // Hábitos
      case 4:
        final timerState = ref.watch(timerNotifierProvider);
        fabIcon = timerState.status == TimerStatus.running
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded;
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: context.surfaceBase,

      // ── PageView body ────────────────────────────────────────────────────
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentPage = index);
          // Publish active tab so pages can react (e.g. Hoy rotates its quote
          // every time you come back to it).
          ref.read(currentTabIndexProvider.notifier).state = index;
        },
        physics: const BouncingScrollPhysics(),
        children: const [
          _KeepAlive(child: HoyPage()),
          _KeepAlive(child: MesPage()),
          _KeepAlive(child: ProyectosPage()),
          _KeepAlive(child: HabitosPage()),
          _KeepAlive(child: EnfoquePage()),
        ],
      ),

      // ── FAB ─────────────────────────────────────────────────────────────
      floatingActionButton: fabIcon == null
          ? null
          : AppFab(
              icon: fabIcon,
              onTap: () {
                switch (_currentPage) {
                  case 0:
                    // Si en Hoy hay un área filtrada, prefilteamos el sheet
                    // para que la nueva tarea caiga directo en esa categoría.
                    final selectedArea = ref.read(selectedAreaProvider);
                    AddTaskBottomSheet.show(
                      context,
                      prefillArea: selectedArea,
                    );
                  case 2:
                    AddProjectBottomSheet.show(context);
                  case 3:
                    AddHabitBottomSheet.show(context);
                  case 4:
                    ref.read(timerNotifierProvider.notifier).toggle();
                  default:
                    break;
                }
              },
              onLongPress: () => QuickCaptureBottomSheet.show(context),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ── Bottom nav bar ───────────────────────────────────────────────────
      bottomNavigationBar: _NavBar(
        pageController: _pageController,
        currentPage: _currentPage,
        tabs: _tabs,
        onTabTap: _goToPage,
        bottomPadding: bottomPadding,
      ),
    );
  }
}

// ── Keep-alive wrapper (preserves page state when swiping away) ────────────
class _KeepAlive extends StatefulWidget {
  final Widget child;
  const _KeepAlive({required this.child});

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// ── Bottom nav bar with real-time sliding indicator ────────────────────────
class _NavBar extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final List<_TabConfig> tabs;
  final ValueChanged<int> onTabTap;
  final double bottomPadding;

  const _NavBar({
    required this.pageController,
    required this.currentPage,
    required this.tabs,
    required this.onTabTap,
    required this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Swipe horizontally on the nav bar itself to jump between pages.
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v.abs() < 200) return;
        final direction = v < 0 ? 1 : -1; // <0 = swipe left → next page
        final target = (currentPage + direction).clamp(0, tabs.length - 1);
        if (target != currentPage) {
          onTabTap(target);
        }
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: BoxDecoration(
              // Superficie sólida (no translucida) para que el blur agregue
              // profundidad sin dejar pasar el contenido scrolleado.
              color: context.surfaceCard,
              border: Border(top: BorderSide(color: context.dividerColor)),
              boxShadow: context.shadowsX.navBarTop,
            ),
            child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final tabWidth = totalWidth / tabs.length;
          const indicatorW = 20.0;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Tab items ────────────────────────────────────────────────
              Row(
                children: List.generate(tabs.length, (i) {
                  final tab = tabs[i];
                  final selected = i == currentPage;
                  return Expanded(
                    child: InkWell(
                      onTap: () => onTabTap(i),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4), // space for indicator
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                tab.icon,
                                key: ValueKey('$i-$selected'),
                                color: selected
                                    ? context.colorPrimary
                                    : context.neutral500,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tab.label,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected
                                    ? context.colorPrimary
                                    : context.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              // ── Sliding indicator (follows finger in real-time) ──────────
              AnimatedBuilder(
                animation: pageController,
                builder: (context, _) {
                  final page = pageController.hasClients
                      ? (pageController.page ?? currentPage.toDouble())
                      : currentPage.toDouble();

                  // Interpolate indicator X position smoothly
                  final left =
                      page * tabWidth + (tabWidth - indicatorW) / 2;

                  return Positioned(
                    top: 0,
                    left: left,
                    child: Container(
                      width: indicatorW,
                      height: 3,
                      decoration: BoxDecoration(
                        color: context.colorPrimary,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colorPrimary.withAlpha(100),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  const _TabConfig(this.icon, this.label);
}
