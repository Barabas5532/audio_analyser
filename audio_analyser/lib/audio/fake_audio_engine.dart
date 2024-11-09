import 'dart:async';
import 'dart:math' as m;

import 'package:audio_analyser/audio/fft_state.dart';
import 'package:audio_analyser/audio/meters_state.dart';
import 'package:logging/logging.dart';

import 'audio_engine.dart';

final _log = Logger('fake_audio_engine');

class FakeAudioEngine extends AudioEngine {
  FakeAudioEngine(this.sampleRate, this.bufferSize) {
    final bufferPeriodMs = bufferSize / sampleRate * 1000;
    _log.info('Timer period: $bufferPeriodMs ms');

    timer = Timer.periodic(Duration(milliseconds: bufferPeriodMs.toInt()),
        (_) => _generateBuffer());
  }

  double sampleRate;
  int bufferSize;

  late final Timer timer;

  late final generator = _SineGenerator(sampleRate, 1000);

  final audioController = StreamController<AudioBuffer>();

  void _generateBuffer() {
    final buffer = generator.generate(bufferSize);
    audioController.add(buffer);
  }

  @override
  void dispose() {
    timer.cancel();
  }

  late final _random = m.Random();

  @override
  Stream<AudioBuffer> get audio => audioController.stream;

  @override
  Stream<MetersState> get meters => Stream.periodic(
        const Duration(seconds: 1),
        (_) => MetersState(rms: m.Random().nextDouble(), fft: FftState(
          frequencies: List.generate(
            128,
                (i) => i * sampleRate / 128.0,
          ),
          magnitude: List.generate(128, (_) => _random.nextDouble()),
        )),
      );
}

class _SineGenerator {
  _SineGenerator(double sampleRate, double frequency)
      : increment = 2 * m.pi * frequency / sampleRate;

  double phase = 0;
  double increment;

  AudioBuffer generate(int count) {
    final buffer = <double>[];

    for (var i = 0; i < count; i++) {
      phase += increment;

      if (phase > 2 * m.pi) {
        phase -= 2 * m.pi;
      }

      buffer.add(m.sin(phase));
    }

    return buffer;
  }
}
