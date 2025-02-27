import 'package:audio_analyser/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('label formatting', () {
    final reference = <double, String>{
      1: '1.00',
      10: '10.0',
      1000: '1.00k',
      0.1: '100m',
      1.234: '1.23',
      12.34: '12.3',
      123.4: '123',
    };

    final result = reference
        .map((key, _) => MapEntry(key, formatTick(key, key.magnitude)));

    expect(result, reference);

    final resultNegative = reference
        .map((key, _) => MapEntry(key, formatTick(-key, (-key).magnitude)));

    expect(resultNegative,
        reference.map((key, value) => MapEntry(key, '-$value')));
  });

  test('label formatting 2', () {
    final reference = <double, String>{
      0.1: '0.10',
      0.01: '0.01',
      0.001: '0.00',
      0.000000000001: '0.00',
    };

    final result = reference
        .map((key, _) => MapEntry(key, formatTick(key, NumberMagnitude.base)));

    expect(result, reference);

    final resultNegative = reference
        .map((key, _) => MapEntry(key, formatTick(-key, NumberMagnitude.base)));

    expect(resultNegative,
        reference.map((key, value) => MapEntry(key, '-$value')));
  });

  test('max magnitude', () {
    final ticks = [-1.2, -0.7, -0.2, 0.3, 0.8];
    expect(ticks.maxMagnitude(), NumberMagnitude.base);
  });
}
