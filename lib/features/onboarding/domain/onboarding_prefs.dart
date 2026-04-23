import 'package:shared_preferences/shared_preferences.dart';

/// Gate de primer uso. Si `hasCompleted` es `false`, el router redirige
/// a /login y de ahí a /onboarding. Al terminar el tour marca `true` y
/// no se vuelve a mostrar.
class OnboardingPrefs {
  static const _kDone = 'onboarding.completed';
  static const _kSkippedLogin = 'onboarding.localAccount';
  static const _kEmail = 'user.email';

  /// Cache que se hidrata en `main.dart` antes del primer frame para que
  /// el redirect del router pueda ser sincrónico.
  static bool cachedCompleted = false;

  static Future<bool> hasCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getBool(_kDone) ?? false;
      cachedCompleted = v;
      return v;
    } catch (_) {
      return false;
    }
  }

  static Future<void> markCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kDone, true);
      cachedCompleted = true;
    } catch (_) {}
  }

  static Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kDone);
      await prefs.remove(_kSkippedLogin);
      cachedCompleted = false;
    } catch (_) {}
  }

  static Future<void> markLocalAccount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSkippedLogin, true);
    } catch (_) {}
  }

  static Future<void> saveEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kEmail, email);
    } catch (_) {}
  }

  static Future<String?> getEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_kEmail);
    } catch (_) {
      return null;
    }
  }
}
