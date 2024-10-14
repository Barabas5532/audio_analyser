import 'package:flutter/material.dart';
import 'proto/generated/audio_analyser.pbgrpc.dart' as grpc;
import 'package:fixnum/fixnum.dart';

class AudioBackend extends ChangeNotifier {
  AudioBackend({required grpc.AudioAnalyserClient client}) : _client = client;

  final grpc.AudioAnalyserClient _client;

  Future<void> sendWindowId(int id) async {
    _client.setWindowId(grpc.WindowId(id: Int64(id)));
  }
}
