import 'package:go_router/go_router.dart';
import 'package:arquitectura_enfoque/core/shell/app_shell.dart';
import 'package:arquitectura_enfoque/features/hoy/presentation/pages/hoy_page.dart';
import 'package:arquitectura_enfoque/features/semana/presentation/pages/semana_page.dart';
import 'package:arquitectura_enfoque/features/proyectos/presentation/pages/proyectos_page.dart';
import 'package:arquitectura_enfoque/features/habitos/presentation/pages/habitos_page.dart';
import 'package:arquitectura_enfoque/features/enfoque/presentation/pages/enfoque_page.dart';
import 'package:arquitectura_enfoque/features/inbox/presentation/pages/inbox_page.dart';
import 'package:arquitectura_enfoque/features/revision/presentation/pages/revision_page.dart';

final appRouter = GoRouter(
  initialLocation: '/hoy',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/hoy', builder: (_, __) => const HoyPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/semana', builder: (_, __) => const SemanaPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/proyectos', builder: (_, __) => const ProyectosPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/habitos', builder: (_, __) => const HabitosPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/enfoque', builder: (_, __) => const EnfoquePage()),
        ]),
      ],
    ),
    GoRoute(path: '/inbox', builder: (_, __) => const InboxPage()),
    GoRoute(path: '/revision', builder: (_, __) => const RevisionPage()),
  ],
);
