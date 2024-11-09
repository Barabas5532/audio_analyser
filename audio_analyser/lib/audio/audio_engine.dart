import 'dart:async';

import 'package:audio_analyser/audio/meters_state.dart';
import 'package:audio_analyser/backend/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;

import 'fft_state.dart';

typedef AudioBuffer = List<double>;

abstract class AudioEngine {
  Stream<AudioBuffer> get audio;

  Stream<MetersState> get meters;

  void dispose();
}

class GrpcAudioEngine implements AudioEngine {
  GrpcAudioEngine({required this.client});

  final grpc.AudioStreamingClient client;

  @override
  Stream<AudioBuffer> get audio =>
      client.getAudioStream(grpc.Void()).map((event) => event.samples);

  @override
  late final Stream<MetersState> meters =
      client.getMeterStream(grpc.Void()).asBroadcastStream().map((event) => MetersState(
          rms: event.rms,
          fft: FftState(
              frequencies: List<double>.generate(
                event.fft.magnitudes.length,
                (i) =>
                    event.fft.sampleRate *
                    i /
                    (event.fft.magnitudes.length - 1),
              ),
              magnitude: event.fft.magnitudes)));

  @override
  void dispose() {}
}
