import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arquitectura_enfoque/core/theme/app_colors.dart';
import 'package:arquitectura_enfoque/core/widgets/app_fab.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/pages/hoy_page.dart';
import 'package:arquitectura_enfoque/features/semana/presentation/pages/semana_page.dart';
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

class _AppShellState extends ConsumerState<AppShell> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const _tabs = [
    _TabConfig(Icons.today_rounded,               'Hoy'),
    _TabConfig(Icons.calendar_view_week_rounded,  'Semana'),
    _TabConfig(Icons.folder_rounded,              'Proyectos'),
    _TabConfig(Icons.loop_rounded,                'Hábitos'),
    _TabConfig(Icons.timer_rounded,               'Enfoque'),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    HapticFeedback.selectionClick();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    IconData? fabIcon;
    if (_currentPage == 0) {
      fabIcon = Icons.add_rounded; // Hoy — new task
    } else if (_currentPage == 1) {
      fabIcon = null; // Semana — no FAB
    } else if (_currentPage == 2) {
      fabIcon = Icons.create_new_folder_rounded;
    } else if (_currentPage == 3) {
      fabIcon = Icons.add_rounded;
    } else if (_currentPage == 4) {
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
        },
        physics: const BouncingScrollPhysics(),
        children: const [
          _KeepAlive(child: HoyPage()),
          _KeepAlive(child: SemanaPage()),
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
                    AddTaskBottomSheet.show(context);
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
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        border: Border(top: BorderSide(color: context.dividerColor)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 8,
            color: Color(0x0A000000),
          ),
        ],
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
    );
  }
}

class _TabConfig {
  final IconData icon;
  final String label;
  const _TabConfig(this.icon, this.label);
}
