//
//  Generated code. Do not modify.
//  source: audio_analyser.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Void extends $pb.GeneratedMessage {
  factory Void() => create();
  Void._() : super();
  factory Void.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Void.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Void',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'audio_analyser.proto'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Void clone() => Void()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Void copyWith(void Function(Void) updates) =>
      super.copyWith((message) => updates(message as Void)) as Void;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Void create() => Void._();
  Void createEmptyInstance() => create();
  static $pb.PbList<Void> createRepeated() => $pb.PbList<Void>();
  @$core.pragma('dart2js:noInline')
  static Void getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Void>(create);
  static Void? _defaultInstance;
}

class WindowId extends $pb.GeneratedMessage {
  factory WindowId({
    $fixnum.Int64? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  WindowId._() : super();
  factory WindowId.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WindowId.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WindowId',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'audio_analyser.proto'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WindowId clone() => WindowId()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WindowId copyWith(void Function(WindowId) updates) =>
      super.copyWith((message) => updates(message as WindowId)) as WindowId;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WindowId create() => WindowId._();
  WindowId createEmptyInstance() => create();
  static $pb.PbList<WindowId> createRepeated() => $pb.PbList<WindowId>();
  @$core.pragma('dart2js:noInline')
  static WindowId getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WindowId>(create);
  static WindowId? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class AudioBuffer extends $pb.GeneratedMessage {
  factory AudioBuffer({
    $core.Iterable<$core.double>? samples,
  }) {
    final $result = create();
    if (samples != null) {
      $result.samples.addAll(samples);
    }
    return $result;
  }
  AudioBuffer._() : super();
  factory AudioBuffer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AudioBuffer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AudioBuffer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'audio_analyser.proto'),
      createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'samples', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  AudioBuffer clone() => AudioBuffer()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  AudioBuffer copyWith(void Function(AudioBuffer) updates) =>
      super.copyWith((message) => updates(message as AudioBuffer))
          as AudioBuffer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AudioBuffer create() => AudioBuffer._();
  AudioBuffer createEmptyInstance() => create();
  static $pb.PbList<AudioBuffer> createRepeated() => $pb.PbList<AudioBuffer>();
  @$core.pragma('dart2js:noInline')
  static AudioBuffer getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AudioBuffer>(create);
  static AudioBuffer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get samples => $_getList(0);
}

/// A state to be displayed on the FFT meter.
class MeterReading_FftReading extends $pb.GeneratedMessage {
  factory MeterReading_FftReading({
    $core.double? sampleRate,
    $core.Iterable<$core.double>? magnitudes,
  }) {
    final $result = create();
    if (sampleRate != null) {
      $result.sampleRate = sampleRate;
    }
    if (magnitudes != null) {
      $result.magnitudes.addAll(magnitudes);
    }
    return $result;
  }
  MeterReading_FftReading._() : super();
  factory MeterReading_FftReading.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory MeterReading_FftReading.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MeterReading.FftReading',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'audio_analyser.proto'),
      createEmptyInstance: create)
    ..a<$core.double>(
        1, _omitFieldNames ? '' : 'sampleRate', $pb.PbFieldType.OF)
    ..p<$core.double>(
        2, _omitFieldNames ? '' : 'magnitudes', $pb.PbFieldType.KF)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MeterReading_FftReading clone() =>
      MeterReading_FftReading()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MeterReading_FftReading copyWith(
          void Function(MeterReading_FftReading) updates) =>
      super.copyWith((message) => updates(message as MeterReading_FftReading))
          as MeterReading_FftReading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MeterReading_FftReading create() => MeterReading_FftReading._();
  MeterReading_FftReading createEmptyInstance() => create();
  static $pb.PbList<MeterReading_FftReading> createRepeated() =>
      $pb.PbList<MeterReading_FftReading>();
  @$core.pragma('dart2js:noInline')
  static MeterReading_FftReading getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MeterReading_FftReading>(create);
  static MeterReading_FftReading? _defaultInstance;

  /// The current sample rate used to obtain this reading.
  @$pb.TagNumber(1)
  $core.double get sampleRate => $_getN(0);
  @$pb.TagNumber(1)
  set sampleRate($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSampleRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearSampleRate() => clearField(1);

  /// The magnitude in linear units of the signal in each bin. The range is
  /// (-1, 1).
  ///
  /// The first entry corresponds to DC, and the last entry to sample_rate / 2.
  @$pb.TagNumber(2)
  $core.List<$core.double> get magnitudes => $_getList(1);
}

class MeterReading extends $pb.GeneratedMessage {
  factory MeterReading({
    $core.double? rms,
    MeterReading_FftReading? fft,
  }) {
    final $result = create();
    if (rms != null) {
      $result.rms = rms;
    }
    if (fft != null) {
      $result.fft = fft;
    }
    return $result;
  }
  MeterReading._() : super();
  factory MeterReading.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory MeterReading.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MeterReading',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'audio_analyser.proto'),
      createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'rms', $pb.PbFieldType.OF)
    ..aOM<MeterReading_FftReading>(2, _omitFieldNames ? '' : 'fft',
        subBuilder: MeterReading_FftReading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  MeterReading clone() => MeterReading()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  MeterReading copyWith(void Function(MeterReading) updates) =>
      super.copyWith((message) => updates(message as MeterReading))
          as MeterReading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MeterReading create() => MeterReading._();
  MeterReading createEmptyInstance() => create();
  static $pb.PbList<MeterReading> createRepeated() =>
      $pb.PbList<MeterReading>();
  @$core.pragma('dart2js:noInline')
  static MeterReading getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MeterReading>(create);
  static MeterReading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get rms => $_getN(0);
  @$pb.TagNumber(1)
  set rms($core.double v) {
    $_setFloat(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRms() => $_has(0);
  @$pb.TagNumber(1)
  void clearRms() => clearField(1);

  @$pb.TagNumber(2)
  MeterReading_FftReading get fft => $_getN(1);
  @$pb.TagNumber(2)
  set fft(MeterReading_FftReading v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFft() => $_has(1);
  @$pb.TagNumber(2)
  void clearFft() => clearField(2);
  @$pb.TagNumber(2)
  MeterReading_FftReading ensureFft() => $_ensure(1);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
