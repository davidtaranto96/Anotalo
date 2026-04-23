import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arquitectura_enfoque/core/router/app_router.dart';
import 'package:arquitectura_enfoque/core/theme/accent.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';
import 'package:arquitectura_enfoque/core/providers/accent_provider.dart';
import 'package:arquitectura_enfoque/core/providers/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    // Observar el acento — repinta el MaterialApp cuando cambia.
    ref.watch(accentProvider);
    final palette = accentPalettes[ref.read(accentProvider)]!;
    return MaterialApp.router(
      title: 'Anótalo',
      theme: AppTheme.light(palette),
      darkTheme: AppTheme.dark(palette),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
