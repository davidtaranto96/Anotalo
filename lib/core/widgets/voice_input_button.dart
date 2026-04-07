import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';

class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onResult;
  final double size;

  const VoiceInputButton({
    super.key,
    required this.onResult,
    this.size = 40,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _available = false;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
          _pulseCtrl.stop();
          _pulseCtrl.reset();
        }
      },
    );
    setState(() {});
  }

  Future<void> _toggleListening() async {
    if (!_available) return;

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      _pulseCtrl.stop();
      _pulseCtrl.reset();
    } else {
      setState(() => _isListening = true);
      _pulseCtrl.repeat(reverse: true);
      await _speech.listen(
        localeId: 'es_AR',
        onResult: (result) {
          if (result.finalResult) {
            widget.onResult(result.recognizedWords);
            setState(() => _isListening = false);
            _pulseCtrl.stop();
            _pulseCtrl.reset();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleListening,
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _isListening
                  ? AppTheme.colorDanger.withAlpha((80 + 80 * _pulseCtrl.value).toInt())
                  : context.surfaceElevated,
              shape: BoxShape.circle,
              border: Border.all(
                color: _isListening ? AppTheme.colorDanger : context.dividerColor,
                width: 1.5,
              ),
              boxShadow: _isListening
                  ? [BoxShadow(
                      color: AppTheme.colorDanger.withAlpha(60),
                      blurRadius: 8 + 4 * _pulseCtrl.value,
                      spreadRadius: 2 * _pulseCtrl.value,
                    )]
                  : null,
            ),
            child: Icon(
              _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
              color: _isListening ? Colors.white : context.textSecondary,
              size: widget.size * 0.5,
            ),
          );
        },
      ),
    );
  }
}
