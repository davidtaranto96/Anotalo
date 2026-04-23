import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/anotalo_toast.dart';
import '../../domain/onboarding_prefs.dart';

/// Pantalla de inicio. Tres caminos:
///   1. Continuar con Google      (placeholder: muestra toast "próximamente")
///   2. Continuar con email       (placeholder)
///   3. Usar sin cuenta           (funcional: marca local-only y sigue
///                                 al onboarding)
///
/// Diseño: "A" brand mark serif italic con glow terracota detrás, luego
/// bajada corta y los tres botones en orden de valor de conversión.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                  'Anótalo',
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
                onTap: () {
                  FeedbackService.instance.tick();
                  showAnotaloToast(
                    context,
                    'Google Sign-In: disponible pronto',
                    tone: ToastTone.info,
                  );
                },
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
  const _GoogleButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
