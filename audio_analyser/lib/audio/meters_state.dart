import 'package:freezed_annotation/freezed_annotation.dart';

part 'meters_state.freezed.dart';

@freezed
class MetersState with _$MetersState {
  factory MetersState({
    required double rms,
  }) = _MetersState;
}
