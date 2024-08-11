import 'dart:async';
import 'dart:math' as m;

import 'package:audio_analyser/embedding/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;
import 'package:flutter/foundation.dart';

import 'trigger.dart';
import 'package:logging/logging.dart';

final _log = Logger('fake_audio_engine');

abstract class AudioEngineBase {
  Stream<AudioBuffer> get audio;

  void dispose();
}

class AudioEngine implements AudioEngineBase {
  AudioEngine({required this.client});

  final grpc.AudioStreamingClient client;

  @override
  Stream<AudioBuffer> get audio =>
      client.getAudioStream(grpc.Void()).map((event) { debugPrint(event.toString()); return event;},).map((event) => event.samples);

  @override
  void dispose() {}
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
