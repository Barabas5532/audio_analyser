import 'dart:async';
import 'dart:math' as m;

import 'package:audio_plot/trigger.dart';
import 'package:logging/logging.dart';


final _log = Logger('fake_audio_engine');

class FakeAudioEngine {
  FakeAudioEngine(this.sampleRate, this.bufferSize, {required this.process}) {
    final bufferPeriodMs = bufferSize / sampleRate * 1000;
    _log.info('Timer period: $bufferPeriodMs ms');

    timer = Timer.periodic(
        Duration(milliseconds: bufferPeriodMs.toInt()), (_) => _generateBuffer());
  }

  void Function(AudioBuffer buffer) process;

  double sampleRate;
  int bufferSize;

  late final Timer timer;

  late final generator = _SineGenerator(sampleRate, 1000);

  void _generateBuffer() {
    final buffer = generator.generate(bufferSize);

    process(buffer);
  }

  void dispose() {
    timer.cancel();
  }
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

      if(phase > 2 * m.pi) {
        phase -= 2 * m.pi;
      }

      buffer.add(m.sin(phase));
    }

    return buffer;
  }
}