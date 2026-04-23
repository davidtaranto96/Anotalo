"""
Generate the 5 feedback WAVs without external deps.
Writes to ../../../assets/sounds/ (the Flutter assets folder).
Uses only stdlib (struct, math, wave).

Run:   python handoff/assets/sounds/gen.py
"""
from __future__ import annotations

import math
import os
import struct
import wave

SR = 44100
OUT_DIR = os.path.normpath(
    os.path.join(os.path.dirname(__file__), "..", "..", "..", "assets", "sounds")
)
os.makedirs(OUT_DIR, exist_ok=True)


def envelope(n: int, attack_frac: float = 0.05, release_frac: float = 0.70) -> list[float]:
    attack_n = max(1, int(n * attack_frac))
    release_start = max(attack_n + 1, int(n * release_frac))
    env = [1.0] * n
    for i in range(attack_n):
        env[i] = i / attack_n
    # exponential release
    rel_len = n - release_start
    for i, idx in enumerate(range(release_start, n)):
        env[idx] = math.exp(-6 * i / max(1, rel_len))
    return env


def tone(freq: float, dur: float, vol: float, wave_type: str = "sine",
         freq_end: float | None = None) -> list[int]:
    n = int(dur * SR)
    samples: list[int] = []
    phase = 0.0
    for i in range(n):
        t = i / SR
        f = freq if freq_end is None else freq + (freq_end - freq) * (i / n)
        phase += 2 * math.pi * f / SR
        if wave_type == "sine":
            s = math.sin(phase)
        elif wave_type == "triangle":
            frac = (phase / (2 * math.pi)) % 1.0
            s = 4 * abs(frac - 0.5) - 1
        elif wave_type == "sawtooth":
            frac = (phase / (2 * math.pi)) % 1.0
            s = 2 * frac - 1
        else:
            s = 0.0
        samples.append(s)

    env = envelope(n)
    clipped = [max(-1.0, min(1.0, s * env[i] * vol)) for i, s in enumerate(samples)]
    return [int(round(v * 32767)) for v in clipped]


def write_wav(path: str, samples: list[int]) -> None:
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(b"".join(struct.pack("<h", s) for s in samples))
    print(f"wrote {os.path.relpath(path)}  ({len(samples)} samples, {len(samples)/SR*1000:.0f}ms)")


def main() -> None:
    write_wav(os.path.join(OUT_DIR, "tick.wav"), tone(880, 0.050, 0.06, "sine"))
    write_wav(os.path.join(OUT_DIR, "success.wav"),
              tone(660, 0.120, 0.08, "sine", freq_end=990))
    write_wav(os.path.join(OUT_DIR, "warn.wav"), tone(320, 0.120, 0.10, "triangle"))
    write_wav(os.path.join(OUT_DIR, "danger.wav"), tone(180, 0.180, 0.12, "sawtooth"))
    write_wav(os.path.join(OUT_DIR, "toggle.wav"), tone(520, 0.040, 0.05, "sine"))


if __name__ == "__main__":
    main()
