import 'dart:async';

import 'package:audio_analyser/audio/meters_state.dart';
import 'package:audio_analyser/backend/generator.dart';
import 'package:audio_analyser/backend/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;

typedef AudioBuffer = List<double>;

abstract class AudioEngine {
  Stream<AudioBuffer> get audio;

  Stream<MetersState> get meters;

  GeneratorService get generator;

  void dispose();
}

class GrpcAudioEngine implements AudioEngine {
  GrpcAudioEngine(
      {required this.streamingClient, required this.generatorClient});

  final grpc.AudioStreamingClient streamingClient;
  final grpc.AudioGeneratorClient generatorClient;

  @override
  Stream<AudioBuffer> get audio =>
      streamingClient.getAudioStream(grpc.Void()).map((event) => event.samples);

  @override
  Stream<MetersState> get meters => streamingClient
      .getMeterStream(grpc.Void())
      .map((event) => MetersState(rms: event.rms));

  @override
  void dispose() {}

  @override
  late GeneratorService generator = GeneratorService(client: generatorClient);
}
