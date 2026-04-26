import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/logic/notification_service.dart';
import '../../../../core/models/task_area.dart';
import '../../../../core/providers/accent_provider.dart';
import '../../../../core/theme/accent.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/anotalo_toast.dart';
import '../../../habitos/domain/models/habit.dart';
import '../../../habitos/presentation/providers/habit_provider.dart';
import '../../domain/onboarding_prefs.dart';

/// Tour de 4 pasos que corre tras el login local.
///   1. Bienvenida + features
///   2. Multi-select de áreas (informativo: marcamos favoritas)
///   3. Elegir acento (live-preview del tema)
///   4. Multi-select de hábitos iniciales
/// Al finalizar: crea los hábitos elegidos, marca onboarding como hecho
/// y redirige a "/".
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _page = PageController();
  int _step = 0;

  final Set<String> _selectedAreas = {'trabajo', 'personal'};
  final Set<String> _selectedHabits = {'agua', 'leer'};
  // Hora elegida por hábito; null si el usuario no quiso recordatorio.
  final Map<String, int> _reminderHour = {};

  static const int _total = 4;

  /// Horas preset del recordatorio (spec del handoff).
  static const List<int> _reminderOptions = [7, 8, 12, 18, 20, 21, 22, 23];

  static const List<_HabitSeed> _habitSeeds = [
    _HabitSeed('agua', 'Tomar agua', '💧', '#4A8FA8'),
    _HabitSeed('meditar', 'Meditar', '🧘', '#9B6BBB'),
    _HabitSeed('correr', 'Salir a correr', '🏃', '#5A8A6A'),
    _HabitSeed('leer', 'Leer un rato', '📚', '#D97757'),
    _HabitSeed('caminar', 'Caminar', '🚶', '#C4963A'),
    _HabitSeed('dormir', 'Dormir temprano', '😴', '#6B7280'),
  ];

  Future<void> _next() async {
    FeedbackService.instance.tick();
    if (_step == _total - 1) {
      await _finish();
      return;
    }
    await _page.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    // 1. Crear hábitos seleccionados + programar recordatorios.
    try {
      final service = ref.read(habitServiceProvider);
      for (final id in _selectedHabits) {
        final seed = _habitSeeds.firstWhere((h) => h.id == id,
            orElse: () => const _HabitSeed('', '', '', '#D97757'));
        if (seed.id.isEmpty) continue;
        final habitId = const Uuid().v4();
        await service.addHabit(Habit(
          id: habitId,
          title: seed.title,
          frequency: HabitFrequency.daily,
          icon: seed.emoji,
          color: seed.color,
          createdAt: DateTime.now(),
        ));
        // Si el usuario eligió un horario, programamos la notif diaria.
        // notificationId estable = hash del habitId para poder regenerar.
        final hour = _reminderHour[id];
        if (hour != null) {
          await NotificationService().scheduleHabitReminder(
            notificationId: habitId.hashCode & 0x7fffffff,
            habitTitle: seed.title,
            hour: hour,
            minute: 0,
          );
        }
      }
    } catch (e) {
      debugPrint('Onboarding: no se pudieron crear hábitos: $e');
    }

    // 2. Marcar done y redirigir.
    await OnboardingPrefs.markCompleted();
    if (!mounted) return;
    showAnotaloToast(context, '¡Listo! Arrancá a anotar', tone: ToastTone.success);
    context.go('/');
  }

  Future<void> _skip() async {
    FeedbackService.instance.toggle();
    await OnboardingPrefs.markCompleted();
    if (!mounted) return;
    context.go('/');
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots + skip
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 20, 8),
              child: Row(
                children: [
                  for (var i = 0; i < _total; i++) ...[
                    _ProgressDot(active: i == _step, past: i < _step),
                    if (i != _total - 1) const SizedBox(width: 6),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: _skip,
                    child: Text(
                      'Saltar →',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _StepWelcome(),
                  _StepAreas(
                    selected: _selectedAreas,
                    onToggle: (id) => setState(() {
                      if (_selectedAreas.contains(id)) {
                        _selectedAreas.remove(id);
                      } else {
                        _selectedAreas.add(id);
                      }
                      FeedbackService.instance.toggle();
                    }),
                  ),
                  const _StepAccent(),
                  _StepHabits(
                    seeds: _habitSeeds,
                    selected: _selectedHabits,
                    reminderHour: _reminderHour,
                    reminderOptions: _reminderOptions,
                    onToggle: (id) => setState(() {
                      if (_selectedHabits.contains(id)) {
                        _selectedHabits.remove(id);
                        _reminderHour.remove(id);
                      } else {
                        _selectedHabits.add(id);
                      }
                      FeedbackService.instance.toggle();
                    }),
                    onPickReminder: (id, hour) => setState(() {
                      if (hour == null) {
                        _reminderHour.remove(id);
                      } else {
                        _reminderHour[id] = hour;
                      }
                      FeedbackService.instance.toggle();
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _step == _total - 1 ? 'Empezar' : 'Continuar',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressDot extends StatelessWidget {
  const _ProgressDot({required this.active, required this.past});
  final bool active;
  final bool past;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final Color color;
    if (active) {
      color = primary;
    } else if (past) {
      color = primary.withValues(alpha: 0.5);
    } else {
      color = context.dividerColor;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 1 — Bienvenida
// ═══════════════════════════════════════════════════════════════

class _StepWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          Text(
            'Bienvenido a\nApunto',
            style: GoogleFonts.fraunces(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: -0.6,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Tu sistema de enfoque. Capturá, organizá y cerrá el día.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _FeatureChip(
            icon: Icons.today_rounded,
            title: 'Hoy · Semana',
            body: 'Priorizá el día y planificá la semana.',
            color: primary,
          ),
          const SizedBox(height: 10),
          const _FeatureChip(
            icon: Icons.loop_rounded,
            title: 'Hábitos',
            body: 'Racha diaria con recordatorios.',
            color: Color(0xFF5A8A6A),
          ),
          const SizedBox(height: 10),
          const _FeatureChip(
            icon: Icons.timer_rounded,
            title: 'Enfoque',
            body: 'Timer Pomodoro y sesiones profundas.',
            color: Color(0xFFC44B4B),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: context.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 2 — Áreas
// ═══════════════════════════════════════════════════════════════

class _StepAreas extends StatelessWidget {
  const _StepAreas({required this.selected, required this.onToggle});
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            '¿Qué querés ordenar?',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elegí las áreas que usás. Podés cambiarlas cuando quieras.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                for (final a in kBuiltinAreas)
                  _AreaTile(
                    area: a,
                    active: selected.contains(a.id),
                    onTap: () => onToggle(a.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaTile extends StatelessWidget {
  const _AreaTile({
    required this.area,
    required this.active,
    required this.onTap,
  });
  final TaskArea area;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? area.color.withValues(alpha: 0.14)
              : context.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? area.color : context.dividerColor,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(area.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                area.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ),
            if (active)
              Icon(Icons.check_circle_rounded, size: 18, color: area.color),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 3 — Acento
// ═══════════════════════════════════════════════════════════════

class _StepAccent extends ConsumerWidget {
  const _StepAccent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(accentProvider);
    final palette = accentPalettes[current]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Elegí tu color',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seis paletas curadas. Toda la app se repinta al instante.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // Preview — mock compacto de la UI
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
              color: context.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué vas a lograr hoy?',
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 32,
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: palette.primary, width: 2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Tu primera tarea',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: palette.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Completar',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: palette.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: palette.primaryBorder),
                      ),
                      child: Text(
                        palette.label,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: palette.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Grid 6 swatches
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: AnotaloAccent.values.map((a) {
              final pal = accentPalettes[a]!;
              final active = a == current;
              return GestureDetector(
                onTap: () {
                  FeedbackService.instance.toggle();
                  ref.read(accentProvider.notifier).set(a);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pal.primary,
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: pal.primary.withValues(alpha: 0.5),
                              blurRadius: 0,
                              spreadRadius: 3,
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: active ? pal.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: active
                      ? const Icon(Icons.check_rounded,
                          size: 20, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// STEP 4 — Hábitos
// ═══════════════════════════════════════════════════════════════

class _HabitSeed {
  final String id;
  final String title;
  final String emoji;
  final String color;
  const _HabitSeed(this.id, this.title, this.emoji, this.color);
}

class _StepHabits extends StatelessWidget {
  const _StepHabits({
    required this.seeds,
    required this.selected,
    required this.reminderHour,
    required this.reminderOptions,
    required this.onToggle,
    required this.onPickReminder,
  });
  final List<_HabitSeed> seeds;
  final Set<String> selected;
  final Map<String, int> reminderHour;
  final List<int> reminderOptions;
  final ValueChanged<String> onToggle;
  final void Function(String id, int? hour) onPickReminder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Arrancá con tus hábitos',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elegí los que quieras trackear. Opcional: sumá un recordatorio.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: seeds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final s = seeds[i];
                final active = selected.contains(s.id);
                final color = _hex(s.color);
                final currentHour = reminderHour[s.id];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: active
                        ? color.withValues(alpha: 0.12)
                        : context.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active ? color : context.dividerColor,
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => onToggle(s.id),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Text(s.emoji,
                                  style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  s.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: context.textPrimary,
                                  ),
                                ),
                              ),
                              if (active)
                                Icon(Icons.check_circle_rounded,
                                    size: 20, color: color),
                            ],
                          ),
                        ),
                      ),
                      // Fila de horarios: solo visible cuando el hábito
                      // está seleccionado. "Sin recordatorio" es la
                      // opción default (neutro).
                      if (active)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _HourChip(
                                  label: 'Sin recordatorio',
                                  active: currentHour == null,
                                  color: color,
                                  onTap: () => onPickReminder(s.id, null),
                                ),
                                for (final h in reminderOptions)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: _HourChip(
                                      label:
                                          '${h.toString().padLeft(2, '0')}:00',
                                      active: currentHour == h,
                                      color: color,
                                      onTap: () => onPickReminder(s.id, h),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _hex(String hex) {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }
}

class _HourChip extends StatelessWidget {
  const _HourChip({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? color : context.dividerColor,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : context.textSecondary,
          ),
        ),
      ),
    );
  }
}
