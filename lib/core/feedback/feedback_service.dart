import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Los 5 presets de feedback del sistema 1.6 — haptic + audio corto.
/// WAVs bundleados en `assets/sounds/` (ver `handoff/assets/sounds/gen.py`).
enum FeedbackKind { tick, success, warn, danger, toggle }

class FeedbackService extends ChangeNotifier {
  FeedbackService._();
  static final FeedbackService instance = FeedbackService._();

  static const _kSounds = 'feedback.sounds';
  static const _kHaptics = 'feedback.haptics';

  bool _soundsOn = true;
  bool _hapticsOn = true;
  bool _loaded = false;
  bool _audioReady = false;

  // Un player dedicado por preset evita que dos sonidos simultáneos se
  // pisen y que se apilen glitches cuando el usuario spamea.
  final Map<FeedbackKind, AudioPlayer> _players = {
    for (final k in FeedbackKind.values) k: AudioPlayer(),
  };

  bool get soundsOn => _soundsOn;
  bool get hapticsOn => _hapticsOn;

  Future<void> init() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      _soundsOn = prefs.getBool(_kSounds) ?? true;
      _hapticsOn = prefs.getBool(_kHaptics) ?? true;
      _loaded = true;
      notifyListeners();
    } catch (_) {
      // defaults quedan como están
    }
    // Pre-cargar las fuentes para que el primer play no tenga delay de I/O.
    await _warmupPlayers();
  }

  Future<void> _warmupPlayers() async {
    try {
      for (final kind in FeedbackKind.values) {
        final p = _players[kind]!;
        await p.setReleaseMode(ReleaseMode.stop);
        await p.setPlayerMode(PlayerMode.lowLatency);
        await p.setSource(AssetSource('sounds/${kind.name}.wav'));
        await p.setVolume(_volumeFor(kind));
      }
      _audioReady = true;
    } catch (e) {
      if (kDebugMode) debugPrint('[FeedbackService] warmup failed: $e');
      _audioReady = false;
    }
  }

  double _volumeFor(FeedbackKind kind) => switch (kind) {
        FeedbackKind.tick => 0.8,
        FeedbackKind.toggle => 0.7,
        FeedbackKind.success => 1.0,
        FeedbackKind.warn => 1.0,
        FeedbackKind.danger => 1.0,
      };

  Future<void> setSoundsOn(bool v) async {
    _soundsOn = v;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kSounds, v);
    } catch (_) {}
  }

  Future<void> setHapticsOn(bool v) async {
    _hapticsOn = v;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kHaptics, v);
    } catch (_) {}
  }

  Future<void> play(FeedbackKind kind) async {
    if (_hapticsOn) {
      _playHaptic(kind);
    }
    if (_soundsOn) {
      await _playSound(kind);
    }
  }

  void _playHaptic(FeedbackKind kind) {
    switch (kind) {
      case FeedbackKind.tick:
      case FeedbackKind.toggle:
        HapticFeedback.selectionClick();
      case FeedbackKind.success:
        HapticFeedback.lightImpact();
      case FeedbackKind.warn:
        HapticFeedback.mediumImpact();
      case FeedbackKind.danger:
        HapticFeedback.heavyImpact();
    }
  }

  Future<void> _playSound(FeedbackKind kind) async {
    if (!_audioReady) return;
    try {
      final p = _players[kind]!;
      // stop + resume garantiza que taps rápidos no apilen instancias.
      await p.stop();
      await p.resume();
    } catch (e) {
      if (kDebugMode) debugPrint('[FeedbackService] play ${kind.name}: $e');
    }
  }

  // Shortcuts
  Future<void> tick() => play(FeedbackKind.tick);
  Future<void> success() => play(FeedbackKind.success);
  Future<void> warn() => play(FeedbackKind.warn);
  Future<void> danger() => play(FeedbackKind.danger);
  Future<void> toggle() => play(FeedbackKind.toggle);
}
