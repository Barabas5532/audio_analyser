import 'dart:async';

import 'package:audio_analyser/audio/meters_state.dart';
import 'package:audio_analyser/backend/generator.dart';
import 'package:audio_analyser/backend/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;

import 'fft_state.dart';

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
  late final Stream<MetersState> meters = streamingClient
      .getMeterStream(grpc.Void())
      .asBroadcastStream()
      .map((event) => MetersState(
          rms: event.rms,
          fft: FftState(
              frequencies: List<double>.generate(
                event.fft.magnitudes.length,
                (i) =>
                    (event.fft.sampleRate / 2) *
                    i /
                    (event.fft.magnitudes.length - 1),
              ),
              magnitude: event.fft.magnitudes)));

  @override
  void dispose() {}

  @override
  late GeneratorService generator = GeneratorService(client: generatorClient);
}
