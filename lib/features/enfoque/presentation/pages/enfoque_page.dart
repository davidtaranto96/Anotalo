import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/format_utils.dart';
import '../providers/timer_provider.dart';
import '../../domain/models/timer_state.dart';
import '../widgets/timer_ring.dart';
import '../widgets/timer_mode_selector.dart';

class EnfoquePage extends ConsumerWidget {
  const EnfoquePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timerNotifierProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Enfoque',
                      style: GoogleFonts.inter(
                          fontSize: 22, fontWeight: FontWeight.w700)),
                  if (state.sessionsCompleted > 0)
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded,
                            color: AppTheme.colorWarning, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          '${state.sessionsCompleted} sesiones',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: AppTheme.colorWarning),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TimerModeSelector(
              selected: state.mode,
              onSelect: (mode) {
                if (state.status != TimerStatus.running) {
                  notifier.setMode(mode);
                }
              },
            ),
            const Spacer(),
            // Timer ring
            TimerRing(
              progress: state.progress,
              timeDisplay: formatDuration(state.remainingSeconds),
              isRunning: state.status == TimerStatus.running,
            ),
            const SizedBox(height: 24),
            // Status label
            Text(
              _statusLabel(state.status),
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppTheme.colorNeutral),
            ),
            const Spacer(),
            // Controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state.status != TimerStatus.idle)
                  IconButton(
                    onPressed: notifier.stop,
                    icon: const Icon(Icons.stop_rounded),
                    color: AppTheme.colorDanger,
                    iconSize: 32,
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.colorDanger.withAlpha(26),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                const SizedBox(width: 20),
                // Main play/pause FAB
                GestureDetector(
                  onTap: notifier.toggle,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: state.status == TimerStatus.running
                          ? AppTheme.colorPrimary.withAlpha(230)
                          : AppTheme.colorPrimary,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        key: ValueKey(state.status),
                        state.status == TimerStatus.running
                            ? Icons.pause_rounded
                            : state.status == TimerStatus.completed
                                ? Icons.refresh_rounded
                                : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _statusLabel(TimerStatus s) => switch (s) {
    TimerStatus.idle      => 'Listo para comenzar',
    TimerStatus.running   => 'En progreso...',
    TimerStatus.paused    => 'Pausado',
    TimerStatus.completed => '¡Sesión completada!',
  };
}
