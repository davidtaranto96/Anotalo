import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:arquitectura_enfoque/core/router/page_transitions.dart';
import 'package:arquitectura_enfoque/core/shell/app_shell.dart';
import 'package:arquitectura_enfoque/features/inbox/presentation/pages/inbox_page.dart';
import 'package:arquitectura_enfoque/features/onboarding/domain/onboarding_prefs.dart';
import 'package:arquitectura_enfoque/features/onboarding/presentation/pages/email_login_page.dart';
import 'package:arquitectura_enfoque/features/onboarding/presentation/pages/login_page.dart';
import 'package:arquitectura_enfoque/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/daily_review_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/review_history_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/weekly_review_page.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/pages/settings_page.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/pages/manage_areas_page.dart';
import 'package:arquitectura_enfoque/features/novedades/presentation/pages/novedades_page.dart';

GoRoute _axisRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (ctx, state) => sharedAxisXPage(
      key: state.pageKey,
      child: builder(ctx, state),
    ),
  );
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final done = OnboardingPrefs.cachedCompleted;
    final loc = state.uri.path;
    final inOnboarding = loc == '/login' ||
        loc == '/login/email' ||
        loc == '/onboarding';
    if (!done && !inOnboarding) return '/login';
    if (done && inOnboarding) return '/';
    return null;
  },
  routes: [
    // La home es el shell con PageView propio — no le aplicamos la
    // transición compartida porque rompe el ciclo de keep-alive de tabs.
    GoRoute(path: '/', builder: (_, __) => const AppShell()),

    // Login y onboarding tienen su propia coreografía — fade simple es
    // más apropiado que el slide; usamos el default de go_router.
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/login/email', builder: (_, __) => const EmailLoginPage()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),

    // El resto usa shared-axis X 300ms — match del spec (animations.md §4).
    _axisRoute(path: '/inbox', builder: (_, __) => const InboxPage()),
    _axisRoute(
        path: '/review',
        builder: (_, state) =>
            DailyReviewPage(dayId: state.uri.queryParameters['day'])),
    _axisRoute(
        path: '/review-history',
        builder: (_, __) => const ReviewHistoryPage()),
    _axisRoute(
        path: '/weekly-review',
        builder: (_, __) => const WeeklyReviewPage()),
    _axisRoute(
        path: '/manage-areas', builder: (_, __) => const ManageAreasPage()),
    _axisRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
    _axisRoute(path: '/novedades', builder: (_, __) => const NovedadesPage()),
  ],
);
