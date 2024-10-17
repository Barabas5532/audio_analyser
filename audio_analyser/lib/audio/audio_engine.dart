import 'dart:async';

import 'package:audio_analyser/audio/meters_state.dart';
import 'package:audio_analyser/backend/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;

import 'fft_state.dart';

typedef AudioBuffer = List<double>;

abstract class AudioEngine {
  Stream<AudioBuffer> get audio;
  Stream<MetersState> get meters;
  Stream<FftState> get fft;

  void dispose();
}

class GrpcAudioEngine implements AudioEngine {
  GrpcAudioEngine({required this.client});

  final grpc.AudioStreamingClient client;

  @override
  Stream<AudioBuffer> get audio =>
      client.getAudioStream(grpc.Void()).map((event) => event.samples);

  @override
  Stream<MetersState> get meters => client
      .getMeterStream(grpc.Void())
      .map((event) => MetersState(rms: event.rms));

  @override
  // TODO: implement fft
  Stream<FftState> get fft => throw UnimplementedError();

  @override
  void dispose() {}
}
