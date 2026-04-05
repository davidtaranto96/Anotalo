import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arquitectura_enfoque/core/router/app_router.dart';
import 'package:arquitectura_enfoque/core/theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Arquitectura de Enfoque',
      theme: AppTheme.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
