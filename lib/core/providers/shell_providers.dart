import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentTabIndexProvider = StateProvider<int>((ref) => 0);

/// Currently active area filter inside Hoy. `null` = "Todo" / sin filtro.
/// Lifted into a provider so the FAB (lives in AppShell, not HoyPage) can
/// pre-fill the area when adding a new task while the user is filtered.
final selectedAreaProvider = StateProvider<String?>((ref) => null);
