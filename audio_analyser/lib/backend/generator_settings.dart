import 'package:freezed_annotation/freezed_annotation.dart';

part 'generator_settings.freezed.dart';

@freezed
class GeneratorSettings with _$GeneratorSettings {
  factory GeneratorSettings({
    required bool enabled,
    required double level,
    required double frequency,
  }) = _GeneratorSettings;
}
