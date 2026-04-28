import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/logic/auth_service.dart';
import '../../../../core/logic/drive_backup_service.dart';
import '../../../../core/providers/backup_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/anotalo_toast.dart';
import '../../domain/onboarding_prefs.dart';

/// Pantalla de inicio. Tres caminos:
///   1. Continuar con Google      (Firebase Auth + google_sign_in)
///   2. Continuar con email       (placeholder local-only)
///   3. Usar sin cuenta           (marca local-only y sigue al onboarding)
///
/// Diseño: "A" brand mark serif italic con glow terracota detrás, luego
/// bajada corta y los tres botones en orden de valor de conversión.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _signingIn = false;

  Future<void> _signInWithGoogle() async {
    if (_signingIn) return;
    FeedbackService.instance.tick();
    setState(() => _signingIn = true);
    try {
      // Capturamos el email guardado de la sesión anterior (si la
      // hubo) ANTES de loguearnos. Después comparamos con el nuevo
      // email para detectar cambio de cuenta.
      final previousEmail = await OnboardingPrefs.getEmail();

      final user = await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      if (user == null) {
        // El usuario canceló el diálogo — silencio, no toast.
        setState(() => _signingIn = false);
        return;
      }

      // Cambio de cuenta: si había un email previo distinto del actual,
      // y el onboarding ya estaba completado (es decir, hay datos
      // locales del user anterior), preguntamos qué hacer.
      final isSwitchingAccount = previousEmail != null &&
          previousEmail.isNotEmpty &&
          user.email != null &&
          previousEmail != user.email &&
          OnboardingPrefs.cachedCompleted;

      if (isSwitchingAccount && mounted) {
        final keepLocal = await _askAccountSwitch(previousEmail, user.email!);
        if (!mounted) return;
        if (keepLocal == null) {
          // Cancelado — deslogueamos para no quedar a medias.
          await AuthService.instance.signOut();
          setState(() => _signingIn = false);
          return;
        }
        if (!keepLocal) {
          // El user prefiere arrancar limpio con esta cuenta — vamos
          // a intentar restaurar desde Drive de la cuenta nueva.
          // (Datos locales se reemplazan si hay backup; sino los
          // mantenemos pero los va a sobrescribir el primer auto-backup.)
        }
      }

      // Persistir email actual.
      if (user.email != null) {
        await OnboardingPrefs.saveEmail(user.email!);
      }
      if (!mounted) return;
      showAnotaloToast(
        context,
        '¡Hola ${user.displayName ?? user.email ?? ''}!',
        tone: ToastTone.success,
      );

      // Si hay un backup en su Drive, ofrecer restaurar antes del
      // onboarding. Caso típico: cel nuevo / reinstalación / cambio
      // de cuenta. Si no hay backup o el user dice "no", seguimos
      // al onboarding normal (o directamente a / si ya estaba en
      // onboarded).
      final restored = await _maybeRestoreFromDrive();
      if (!mounted) return;
      if (restored) {
        await OnboardingPrefs.markCompleted();
        if (!mounted) return;
        context.go('/');
      } else if (OnboardingPrefs.cachedCompleted) {
        // Ya estaba onboarded (caso del switch de cuenta sin restore).
        context.go('/');
      } else {
        context.go('/onboarding');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _signingIn = false);
      showAnotaloToast(
        context,
        'No se pudo iniciar sesión: ${e.toString().split(':').last.trim()}',
        tone: ToastTone.warn,
      );
    }
  }

  /// Diálogo cuando el user se loguea con una cuenta distinta a la
  /// anterior. Devuelve `true` si quiere mantener los datos locales,
  /// `false` si quiere reemplazar (vamos a buscar backup de la nueva
  /// cuenta), o `null` si cancela el switch.
  Future<bool?> _askAccountSwitch(String prevEmail, String newEmail) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Cuenta diferente',
            style: GoogleFonts.fraunces(
                fontSize: 18, fontWeight: FontWeight.w600)),
        content: Text(
          'Estabas logueado con $prevEmail y ahora entrás con $newEmail.\n\n'
          'Tus datos locales (tareas, hábitos, notas) son del usuario anterior. '
          '¿Qué querés hacer?',
          style: GoogleFonts.inter(fontSize: 14, height: 1.45),
        ),
        actionsOverflowDirection: VerticalDirection.down,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Mantener datos actuales'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Restaurar de la nueva cuenta'),
          ),
        ],
      ),
    );
  }

  /// Chequea Drive por un backup. Si lo encuentra, ofrece restaurarlo.
  /// Devuelve `true` si el restore se ejecutó (para saltar el onboarding).
  Future<bool> _maybeRestoreFromDrive() async {
    try {
      final backup = ref.read(backupServiceProvider);
      final drive = DriveBackupService.instance(backup);
      final lastTime = await drive.getLastBackupTime();
      if (lastTime == null) return false;
      if (!mounted) return false;

      final ageLabel = _humanizeAge(lastTime);
      final shouldRestore = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Encontramos una copia tuya',
            style: GoogleFonts.fraunces(
                fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Text(
            'En tu Google Drive hay un backup de Apunto $ageLabel. '
            '¿Querés restaurarlo ahora? Si decís que no, podés hacerlo '
            'después desde Configuración.',
            style: GoogleFonts.inter(fontSize: 14, height: 1.45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Empezar de cero'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Restaurar'),
            ),
          ],
        ),
      );
      if (shouldRestore != true) return false;
      if (!mounted) return false;

      // Banner centrado mientras descarga e importa — el toast inferior
      // queda muy lejos de la atención durante una operación importante.
      showAnotaloToast(context, 'Restaurando tus datos...',
          tone: ToastTone.info, centered: true);
      final json = await drive.downloadBackupJson();
      if (json == null) {
        if (!mounted) return false;
        showAnotaloToast(context, 'No se pudo bajar el backup',
            tone: ToastTone.warn, centered: true);
        return false;
      }
      await backup.importFromJson(json);
      if (!mounted) return false;
      showAnotaloToast(context, '¡Listo! Datos restaurados',
          tone: ToastTone.success, centered: true);
      return true;
    } catch (e) {
      if (!mounted) return false;
      showAnotaloToast(context, 'No se pudo restaurar: $e',
          tone: ToastTone.warn, centered: true);
      return false;
    }
  }

  String _humanizeAge(DateTime when) {
    final diff = DateTime.now().difference(when);
    if (diff.inMinutes < 60) return 'de hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'de hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'de hace ${diff.inDays} d';
    return 'del ${DateFormat('d MMM yyyy', 'es').format(when)}';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              // Brand mark con glow
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            primary.withValues(alpha: 0.28),
                            primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'A',
                      style: GoogleFonts.fraunces(
                        fontSize: 120,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: context.textPrimary,
                        height: 1.0,
                        letterSpacing: -4,
                      ),
                    ),
                    Positioned(
                      right: 38,
                      bottom: 48,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Apunto',
                  style: GoogleFonts.fraunces(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Tu sistema de enfoque · Pequeño, diario, repetible.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                    height: 1.45,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // CTAs en orden de valor
              _GoogleButton(
                loading: _signingIn,
                onTap: _signInWithGoogle,
              ),
              const SizedBox(height: 10),
              _EmailButton(
                onTap: () {
                  FeedbackService.instance.tick();
                  context.push('/login/email');
                },
              ),
              const SizedBox(height: 10),
              _LocalOnlyButton(
                onTap: () async {
                  FeedbackService.instance.toggle();
                  await OnboardingPrefs.markLocalAccount();
                  if (!context.mounted) return;
                  context.go('/onboarding');
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Nada sube a la nube. Los datos quedan en tu teléfono.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: context.textTertiary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onTap, this.loading = false});
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0DED9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Conectando...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ] else ...[
              // G monogram simple (sin depender de asset)
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5F3EF),
                ),
                child: Text(
                  'G',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4285F4),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Continuar con Google',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          'Continuar con email',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _LocalOnlyButton extends StatelessWidget {
  const _LocalOnlyButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.dividerColor,
            width: 1.2,
            // dashed feel — no hay DashedBorder built-in; simulación con
            // mayor opacidad del border.
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          'Usar sin cuenta',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.textPrimary,
          ),
        ),
      ),
    );
  }
}
