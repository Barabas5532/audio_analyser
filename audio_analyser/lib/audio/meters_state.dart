import 'package:audio_analyser/audio/fft_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meters_state.freezed.dart';

@freezed
class MetersState with _$MetersState {
  factory MetersState({
    required double rms,
    required FftState fft,
  }) = _MetersState;
}
