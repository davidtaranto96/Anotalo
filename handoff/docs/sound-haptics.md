# Sound & Haptics

Minimalist feedback system — 5 sound presets + matching haptic
patterns. Both opt-in (toggles in Config). All sounds are short
(<200ms) and designed to feel intentional, not decorative.

## The 5 presets

| Kind | When | Sound | Haptic |
|---|---|---|---|
| `tick` | Navigation, taps on non-committing elements | 880Hz sine, 50ms, 6% vol | 6ms |
| `success` | Task completed, habit checked, confirm accepted | 660→990Hz glissando, 120ms, sine | 12ms |
| `warn` | Confirmation dialog opens, warning appears | 320Hz triangle, 120ms, 10% vol | `[6, 40, 6]` pattern |
| `danger` | Destructive confirm (delete, reset) | 180Hz sawtooth, 180ms, 12% vol | `[10, 60, 20]` pattern |
| `toggle` | Switch flipped, accent picked, theme changed | 520Hz sine, 40ms, 5% vol | 8ms |

## Flutter implementation

### Approach A — Pre-rendered WAV files (recommended)

Smallest perceptual latency. Bundle 5 short WAVs in
`assets/sounds/`. Use `audioplayers` package.

```yaml
# pubspec.yaml
dependencies:
  audioplayers: ^6.1.0

flutter:
  assets:
    - assets/sounds/
```

```dart
// lib/feedback/feedback_service.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FeedbackKind { tick, success, warn, danger, toggle }

class FeedbackService {
  FeedbackService._();
  static final instance = FeedbackService._();

  bool _soundsOn = true;
  bool _hapticsOn = true;

  final Map<FeedbackKind, AudioPlayer> _players = {
    for (final k in FeedbackKind.values) k: AudioPlayer(),
  };

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _soundsOn = prefs.getBool('feedback.sounds') ?? true;
    _hapticsOn = prefs.getBool('feedback.haptics') ?? true;
    // Pre-load all sources for instant playback
    for (final kind in FeedbackKind.values) {
      await _players[kind]!.setSource(AssetSource('sounds/${kind.name}.wav'));
      await _players[kind]!.setReleaseMode(ReleaseMode.stop);
    }
  }

  bool get soundsOn => _soundsOn;
  bool get hapticsOn => _hapticsOn;

  Future<void> setSoundsOn(bool v) async {
    _soundsOn = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedback.sounds', v);
  }

  Future<void> setHapticsOn(bool v) async {
    _hapticsOn = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('feedback.haptics', v);
  }

  Future<void> play(FeedbackKind kind) async {
    if (_soundsOn) {
      await _players[kind]!.stop();
      await _players[kind]!.resume();
    }
    if (_hapticsOn) {
      switch (kind) {
        case FeedbackKind.tick:
        case FeedbackKind.toggle:
          HapticFeedback.selectionClick();
          break;
        case FeedbackKind.success:
          HapticFeedback.lightImpact();
          break;
        case FeedbackKind.warn:
          HapticFeedback.mediumImpact();
          break;
        case FeedbackKind.danger:
          HapticFeedback.heavyImpact();
          break;
      }
    }
  }

  // Convenience shortcuts
  Future<void> tick() => play(FeedbackKind.tick);
  Future<void> success() => play(FeedbackKind.success);
  Future<void> warn() => play(FeedbackKind.warn);
  Future<void> danger() => play(FeedbackKind.danger);
  Future<void> toggle() => play(FeedbackKind.toggle);
}
```

### Approach B — Synthesize on-device

Skip bundling WAVs, generate on the fly with `soloud`. More code,
smaller binary, slightly higher first-call latency.

```dart
import 'package:flutter_soloud/flutter_soloud.dart';

await SoLoud.instance.init();
final audio = await SoLoud.instance.loadWaveform(
  WaveForm.sine,
  true,  // superwave
  1.0,   // scale
  0.0,   // detune
);
// Configure freq, duration, then play...
```

## Generating the WAVs

Use the Python script in `handoff/assets/sounds/gen.py`:

```python
# Run once to generate all 5 WAV files
import numpy as np
from scipy.io import wavfile

SR = 44100

def envelope(t, attack=0.005, release_start=None):
    n = len(t)
    env = np.ones(n)
    attack_samples = int(attack * SR)
    env[:attack_samples] = np.linspace(0, 1, attack_samples)
    release_start = release_start or int(n * 0.3)
    env[release_start:] = np.exp(-6 * (t[release_start:] - t[release_start]) / (t[-1] - t[release_start] + 1e-9))
    return env

def tone(freq, dur, vol, wave='sine', freq_end=None):
    t = np.linspace(0, dur, int(dur * SR), endpoint=False)
    f = freq if freq_end is None else np.linspace(freq, freq_end, len(t))
    phase = np.cumsum(2 * np.pi * f / SR)
    if wave == 'sine':
        sig = np.sin(phase)
    elif wave == 'triangle':
        sig = 2 * np.abs(2 * (phase / (2*np.pi) - np.floor(phase / (2*np.pi) + 0.5))) - 1
    elif wave == 'sawtooth':
        sig = 2 * (phase / (2*np.pi) - np.floor(phase / (2*np.pi) + 0.5))
    env = envelope(t)
    return (sig * env * vol * 32767).astype(np.int16)

wavfile.write('tick.wav',    SR, tone(880, 0.05, 0.06, 'sine'))
wavfile.write('success.wav', SR, tone(660, 0.12, 0.08, 'sine', freq_end=990))
wavfile.write('warn.wav',    SR, tone(320, 0.12, 0.10, 'triangle'))
wavfile.write('danger.wav',  SR, tone(180, 0.18, 0.12, 'sawtooth'))
wavfile.write('toggle.wav',  SR, tone(520, 0.04, 0.05, 'sine'))
```

## Where to call it — canonical map

| Action | Call |
|---|---|
| Tap a button (non-destructive) | `FeedbackService.instance.tick()` |
| Toggle a switch | `FeedbackService.instance.toggle()` |
| Pick an accent color | `FeedbackService.instance.toggle()` |
| Complete a task | `FeedbackService.instance.success()` |
| Check a habit for the day | `FeedbackService.instance.success()` |
| Open a confirmation dialog | `FeedbackService.instance.warn()` |
| Confirm non-destructive action | `FeedbackService.instance.success()` |
| Confirm destructive action | `FeedbackService.instance.danger()` |
| Cancel a dialog | `FeedbackService.instance.tick()` |
| Start a Pomodoro session | `FeedbackService.instance.success()` |
| Finish a Pomodoro session | `FeedbackService.instance.success()` (x2, 100ms apart) |

## Don't do

- ❌ Don't play `success` on every tap. It stops feeling like an
  achievement. Reserve it for real completions.
- ❌ Don't use system UISounds — they're too loud and jarring.
- ❌ Don't skip the `await _players[kind]!.stop()` — rapid taps will
  stack up and sound awful.
- ❌ On iOS, `HapticFeedback.heavyImpact()` requires the device to
  not be in silent mode. No workaround; silent mode is respected
  by design.
