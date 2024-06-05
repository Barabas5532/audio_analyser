import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'proto/generated/juce_embed_gtk.pbgrpc.dart' as grpc;
import 'package:fixnum/fixnum.dart';

final _log = Logger("juce_connection");

class AudioBackend extends ChangeNotifier {
  AudioBackend({required grpc.JuceEmbedGtkClient client}) : _client = client {
    _log.info('Requesting initial value');
    client.getParameter(grpc.Void()).then(
      (gain) {
        _gain = gain.value;
        notifyListeners();
      },
    );
  }

  final grpc.JuceEmbedGtkClient _client;
  double? _gain;

  set gain(double? gain) {
    _gain = gain;
    notifyListeners();

    _client.setParameter(grpc.ParameterValue(value: gain));
  }

  double? get gain => _gain;

  Future<void> sendWindowId(int id) async {
    _client.setWindowId(grpc.WindowId(id: Int64(id)));
  }
}
