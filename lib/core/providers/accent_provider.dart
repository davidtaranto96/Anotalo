import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/accent.dart';

/// Riverpod wrapper sobre el ChangeNotifier `AccentController.instance`.
/// Mantenemos una sola fuente de verdad (el singleton) para que screens
/// no-Riverpod puedan usarlo también.
class AccentNotifier extends StateNotifier<AnotaloAccent> {
  AccentNotifier() : super(AccentController.instance.current) {
    AccentController.instance.addListener(_onChange);
  }

  void _onChange() {
    state = AccentController.instance.current;
  }

  Future<void> set(AnotaloAccent accent) => AccentController.instance.set(accent);

  AccentPalette get palette => AccentController.instance.palette;

  @override
  void dispose() {
    AccentController.instance.removeListener(_onChange);
    super.dispose();
  }
}

final accentProvider =
    StateNotifierProvider<AccentNotifier, AnotaloAccent>((ref) => AccentNotifier());
