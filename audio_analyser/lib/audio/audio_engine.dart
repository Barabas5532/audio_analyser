import 'dart:async';

import 'package:audio_analyser/embedding/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;


typedef AudioBuffer = List<double>;

abstract class AudioEngineBase {
  Stream<AudioBuffer> get audio;

  void dispose();
}

class AudioEngine implements AudioEngineBase {
  AudioEngine({required this.client});

  final grpc.AudioStreamingClient client;

  @override
  Stream<AudioBuffer> get audio =>
      client.getAudioStream(grpc.Void()).map((event) => event.samples);

  @override
  void dispose() {}
}

