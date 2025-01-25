//
//  Generated code. Do not modify.
//  source: audio_analyser.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use voidDescriptor instead')
const Void$json = {
  '1': 'Void',
};

/// Descriptor for `Void`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidDescriptor = $convert.base64Decode('CgRWb2lk');

@$core.Deprecated('Use windowIdDescriptor instead')
const WindowId$json = {
  '1': 'WindowId',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
  ],
};

/// Descriptor for `WindowId`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List windowIdDescriptor =
    $convert.base64Decode('CghXaW5kb3dJZBIOCgJpZBgBIAEoBFICaWQ=');

@$core.Deprecated('Use audioBufferDescriptor instead')
const AudioBuffer$json = {
  '1': 'AudioBuffer',
  '2': [
    {'1': 'samples', '3': 1, '4': 3, '5': 2, '10': 'samples'},
  ],
};

/// Descriptor for `AudioBuffer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List audioBufferDescriptor = $convert
    .base64Decode('CgtBdWRpb0J1ZmZlchIYCgdzYW1wbGVzGAEgAygCUgdzYW1wbGVz');

@$core.Deprecated('Use meterReadingDescriptor instead')
const MeterReading$json = {
  '1': 'MeterReading',
  '2': [
    {'1': 'rms', '3': 1, '4': 1, '5': 2, '10': 'rms'},
    {
      '1': 'fft',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.audio_analyser.proto.MeterReading.FftReading',
      '10': 'fft'
    },
  ],
  '3': [MeterReading_FftReading$json],
};

@$core.Deprecated('Use meterReadingDescriptor instead')
const MeterReading_FftReading$json = {
  '1': 'FftReading',
  '2': [
    {'1': 'sample_rate', '3': 1, '4': 1, '5': 2, '10': 'sampleRate'},
    {'1': 'magnitudes', '3': 2, '4': 3, '5': 2, '10': 'magnitudes'},
  ],
};

/// Descriptor for `MeterReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List meterReadingDescriptor = $convert.base64Decode(
    'CgxNZXRlclJlYWRpbmcSEAoDcm1zGAEgASgCUgNybXMSPwoDZmZ0GAIgASgLMi0uYXVkaW9fYW'
    '5hbHlzZXIucHJvdG8uTWV0ZXJSZWFkaW5nLkZmdFJlYWRpbmdSA2ZmdBpNCgpGZnRSZWFkaW5n'
    'Eh8KC3NhbXBsZV9yYXRlGAEgASgCUgpzYW1wbGVSYXRlEh4KCm1hZ25pdHVkZXMYAiADKAJSCm'
    '1hZ25pdHVkZXM=');

@$core.Deprecated('Use generatorSettingsDescriptor instead')
const GeneratorSettings$json = {
  '1': 'GeneratorSettings',
  '2': [
    {'1': 'peak_level', '3': 1, '4': 1, '5': 2, '10': 'peakLevel'},
    {'1': 'frequency', '3': 2, '4': 1, '5': 2, '10': 'frequency'},
    {'1': 'enabled', '3': 3, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `GeneratorSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatorSettingsDescriptor = $convert.base64Decode(
    'ChFHZW5lcmF0b3JTZXR0aW5ncxIdCgpwZWFrX2xldmVsGAEgASgCUglwZWFrTGV2ZWwSHAoJZn'
    'JlcXVlbmN5GAIgASgCUglmcmVxdWVuY3kSGAoHZW5hYmxlZBgDIAEoCFIHZW5hYmxlZA==');
