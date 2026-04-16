import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:arquitectura_enfoque/app/app.dart';
import 'core/logic/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize intl date formatting for Spanish locale (fast, required for UI).
  try {
    await initializeDateFormatting('es', null);
  } catch (e) {
    debugPrint('intl init failed: $e');
  }

  // Lock portrait orientation.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar — brightness is handled by the theme.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Run the app first — notifications init is deferred so a hung plugin call
  // on Android 14 (SCHEDULE_EXACT_ALARM / timezone) never blocks the splash.
  runApp(const ProviderScope(child: App()));

  // Fire-and-forget: initialize notifications after the first frame.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await NotificationService().init().timeout(const Duration(seconds: 5));
      await NotificationService()
          .scheduleFromPrefs()
          .timeout(const Duration(seconds: 5));
    } catch (e, st) {
      debugPrint('NotificationService init skipped: $e\n$st');
    }
  });
}
