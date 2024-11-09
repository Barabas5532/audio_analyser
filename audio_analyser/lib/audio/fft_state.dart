import 'package:freezed_annotation/freezed_annotation.dart';

part 'fft_state.freezed.dart';

@freezed
class FftState with _$FftState {
  factory FftState({
    required List<double> frequencies,
    required List<double> magnitude,
  }) = _FftState;
}
