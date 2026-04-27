import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/feedback/feedback_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/anotalo_toast.dart';
import '../../domain/onboarding_prefs.dart';

/// Form de login por email en 2 pasos.
///
/// Sin backend: el "login" guarda el email localmente en SharedPreferences
/// vía `OnboardingPrefs.saveEmail()`. No hay verificación real. Funciona
/// como gateway de identidad local, consistente con la política del
/// handoff: "Nada sube a la nube."
///
/// Paso 1: email (validación básica de formato).
/// Paso 2: password (solo required, no se valida fuerza — no hay server
/// contra el cual verificar, así que pedirlo más es teatro).
class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  int _step = 0; // 0 = email, 1 = password
  String? _emailError;
  String? _passError;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  bool _isValidEmail(String v) {
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return re.hasMatch(v.trim());
  }

  Future<void> _submit() async {
    if (_step == 0) {
      final v = _emailCtl.text.trim();
      if (!_isValidEmail(v)) {
        setState(() => _emailError = 'Escribí un email válido');
        FeedbackService.instance.warn();
        return;
      }
      setState(() {
        _emailError = null;
        _step = 1;
      });
      FeedbackService.instance.tick();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _passFocus.requestFocus();
      });
    } else {
      final pass = _passCtl.text;
      if (pass.length < 4) {
        setState(() => _passError = 'Mínimo 4 caracteres');
        FeedbackService.instance.warn();
        return;
      }
      FeedbackService.instance.success();
      await OnboardingPrefs.saveEmail(_emailCtl.text.trim());
      await OnboardingPrefs.markLocalAccount();
      if (!mounted) return;
      showAnotaloToast(context, '¡Hola ${_emailCtl.text.trim().split('@').first}!',
          tone: ToastTone.success);
      context.go('/onboarding');
    }
  }

  void _back() {
    if (_step == 0) {
      context.go('/login');
      return;
    }
    setState(() {
      _step = 0;
      _passError = null;
    });
    FeedbackService.instance.tick();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceBase,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back row
                Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      icon: Icon(Icons.arrow_back_rounded,
                          color: context.textSecondary),
                    ),
                    Text(
                      _step == 0 ? 'Paso 1 de 2' : 'Paso 2 de 2',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.textTertiary,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _step == 0 ? 'Tu email' : 'Elegí una clave',
                  style: GoogleFonts.fraunces(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _step == 0
                      ? 'Te sirve para identificar tu cuenta localmente. Nada viaja al servidor.'
                      : 'Esta clave es solo simbólica por ahora — todavía no estamos guardándola. La pedimos para reservar el flujo cuando activemos cuentas reales.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _step == 0
                      ? _EmailField(
                          key: const ValueKey('email'),
                          controller: _emailCtl,
                          focus: _emailFocus,
                          error: _emailError,
                          onSubmit: _submit,
                        )
                      : _PasswordField(
                          key: const ValueKey('pass'),
                          controller: _passCtl,
                          focus: _passFocus,
                          error: _passError,
                          onSubmit: _submit,
                        ),
                ),
                const Spacer(),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(
                      _step == 0 ? 'Continuar' : 'Entrar',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    super.key,
    required this.controller,
    required this.focus,
    required this.error,
    required this.onSubmit,
  });
  final TextEditingController controller;
  final FocusNode focus;
  final String? error;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focus,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => onSubmit(),
      style: GoogleFonts.inter(fontSize: 16, color: context.textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail_outline_rounded, color: context.textTertiary),
        hintText: 'vos@ejemplo.com',
        errorText: error,
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    super.key,
    required this.controller,
    required this.focus,
    required this.error,
    required this.onSubmit,
  });
  final TextEditingController controller;
  final FocusNode focus;
  final String? error;
  final VoidCallback onSubmit;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focus,
      autofocus: true,
      obscureText: _obscure,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => widget.onSubmit(),
      style: GoogleFonts.inter(fontSize: 16, color: context.textPrimary),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline_rounded, color: context.textTertiary),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: context.textTertiary,
          ),
        ),
        hintText: 'Tu clave',
        errorText: widget.error,
      ),
    );
  }
}
