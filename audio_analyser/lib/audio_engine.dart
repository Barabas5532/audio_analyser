import 'dart:async';
import 'dart:math' as m;

import 'trigger.dart';
import 'package:logging/logging.dart';

final _log = Logger('fake_audio_engine');

abstract class AudioEngineBase {
  Stream<AudioBuffer> get audio;

  void dispose();
}

class FakeAudioEngine extends AudioEngineBase {
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

  final controller = StreamController<AudioBuffer>();

  void _generateBuffer() {
    final buffer = generator.generate(bufferSize);
    controller.add(buffer);
  }

  @override
  void dispose() {
    timer.cancel();
  }

  @override
  Stream<AudioBuffer> get audio => controller.stream;
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
