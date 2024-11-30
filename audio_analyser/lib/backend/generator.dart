import 'package:audio_analyser/backend/proto/generated/audio_analyser.pbgrpc.dart'
    as grpc;
import 'package:flutter/foundation.dart';

import 'generator_settings.dart';

class GeneratorService extends ChangeNotifier {
  GeneratorService({required grpc.AudioGeneratorClient client})
      : _client = client;

  final grpc.AudioGeneratorClient _client;
  GeneratorSettings? _settings;

  Future<void> setGeneratorSettings(GeneratorSettings settings) async {
    _settings = settings;
    notifyListeners();

    _client.setGeneratorSettings(grpc.GeneratorSettings(
      enabled: settings.enabled,
      frequency: settings.frequency,
      peakLevel: settings.level,
    ));
  }

  GeneratorSettings? get settings => _settings;
}
