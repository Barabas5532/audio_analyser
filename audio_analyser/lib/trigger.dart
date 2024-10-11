import 'dart:async';

import 'package:circular_buffer/circular_buffer.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'audio/audio_engine.dart';

part 'trigger.freezed.dart';

@freezed
sealed class _TriggerState with _$TriggerState {
  factory _TriggerState.ready({required bool isAbove}) = _TriggerStateReady;

  factory _TriggerState.postTrigger({required int remainingSamples}) =
      _TriggerStatePostTrigger;
}

class Trigger {
  static const double _threshold = 0;
  static const bool _isRisingTrigger = true;

  // initialised so that the first sample doesn't immediately trigger
  var _state = _TriggerState.ready(isAbove: _isRisingTrigger);

  int postTriggerBufferSize = 0;
  int screenBufferSize = 0;

  late CircularBuffer<double> samples;

  void process(AudioBuffer buffer) {
    for (final sample in buffer) {
      switch (_state) {
        case _TriggerStateReady(:final isAbove):
          samples.add(sample);
          if (isAbove) {
            if (sample < _threshold) {
              _state = _TriggerState.ready(isAbove: false);
              if (!_isRisingTrigger) {
                _state = _TriggerState.postTrigger(
                    remainingSamples: postTriggerBufferSize);
              }
            }
          } else {
            if (sample >= _threshold) {
              _state = _TriggerState.ready(isAbove: true);
              if (_isRisingTrigger) {
                _state = _TriggerState.postTrigger(
                    remainingSamples: postTriggerBufferSize);
              }
            }
          }
        case _TriggerStatePostTrigger(:final remainingSamples):
          samples.add(sample);
          if (remainingSamples > 1) {
            _state = _TriggerState.postTrigger(
                remainingSamples: remainingSamples - 1);
          } else {
            _state = _TriggerState.ready(isAbove: _isRisingTrigger);
            _eventController.add([...samples]);
          }
      }
    }
  }

  /// Set the post-trigger buffer size.
  ///
  /// This is the count of samples that are going to be plotted on the screen
  /// after the trigger.
  ///
  /// Once triggered, this many samples are collected before a triggered buffer
  /// is sent to the output.
  void setPostTriggerBufferSize(int postTriggerBufferSize) {
    this.postTriggerBufferSize = postTriggerBufferSize;
  }

  void setScreenBufferSize(int screenBufferSize) {
    this.screenBufferSize = screenBufferSize;
    samples = CircularBuffer<double>(screenBufferSize);
  }

  final _eventController = StreamController<AudioBuffer>();

  Stream<AudioBuffer> get triggered => _eventController.stream;

  void dispose() {
    _eventController.close();
  }
}
