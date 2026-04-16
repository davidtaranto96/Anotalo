import 'package:go_router/go_router.dart';
import 'package:arquitectura_enfoque/core/shell/app_shell.dart';
import 'package:arquitectura_enfoque/features/inbox/presentation/pages/inbox_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/revision_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/daily_review_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/review_history_page.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/pages/settings_page.dart';
import 'package:arquitectura_enfoque/features/settings/presentation/pages/manage_areas_page.dart';
import 'package:arquitectura_enfoque/features/novedades/presentation/pages/novedades_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',               builder: (_, __) => const AppShell()),
    GoRoute(path: '/inbox',          builder: (_, __) => const InboxPage()),
    GoRoute(path: '/revision',       builder: (_, __) => const RevisionPage()),
    GoRoute(path: '/review',         builder: (_, state) =>
        DailyReviewPage(dayId: state.uri.queryParameters['day'])),
    GoRoute(path: '/review-history', builder: (_, __) => const ReviewHistoryPage()),
    GoRoute(path: '/manage-areas',   builder: (_, __) => const ManageAreasPage()),
    GoRoute(path: '/settings',       builder: (_, __) => const SettingsPage()),
    GoRoute(path: '/novedades',      builder: (_, __) => const NovedadesPage()),
  ],
);
