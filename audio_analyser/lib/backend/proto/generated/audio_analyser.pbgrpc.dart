//
//  Generated code. Do not modify.
//  source: audio_analyser.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'audio_analyser.pb.dart' as $0;

export 'audio_analyser.pb.dart';

@$pb.GrpcServiceName('audio_analyser.proto.AudioAnalyser')
class AudioAnalyserClient extends $grpc.Client {
  static final _$setWindowId = $grpc.ClientMethod<$0.WindowId, $0.Void>(
      '/audio_analyser.proto.AudioAnalyser/SetWindowId',
      ($0.WindowId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Void.fromBuffer(value));

  AudioAnalyserClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Void> setWindowId($0.WindowId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setWindowId, request, options: options);
  }
}

@$pb.GrpcServiceName('audio_analyser.proto.AudioAnalyser')
abstract class AudioAnalyserServiceBase extends $grpc.Service {
  $core.String get $name => 'audio_analyser.proto.AudioAnalyser';

  AudioAnalyserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WindowId, $0.Void>(
        'SetWindowId',
        setWindowId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WindowId.fromBuffer(value),
        ($0.Void value) => value.writeToBuffer()));
  }

  $async.Future<$0.Void> setWindowId_Pre(
      $grpc.ServiceCall call, $async.Future<$0.WindowId> request) async {
    return setWindowId(call, await request);
  }

  $async.Future<$0.Void> setWindowId(
      $grpc.ServiceCall call, $0.WindowId request);
}

@$pb.GrpcServiceName('audio_analyser.proto.AudioStreaming')
class AudioStreamingClient extends $grpc.Client {
  static final _$getAudioStream = $grpc.ClientMethod<$0.Void, $0.AudioBuffer>(
      '/audio_analyser.proto.AudioStreaming/GetAudioStream',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AudioBuffer.fromBuffer(value));
  static final _$getMeterStream = $grpc.ClientMethod<$0.Void, $0.MeterReading>(
      '/audio_analyser.proto.AudioStreaming/GetMeterStream',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MeterReading.fromBuffer(value));

  AudioStreamingClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.AudioBuffer> getAudioStream($0.Void request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getAudioStream, $async.Stream.fromIterable([request]),
        options: options);
  }

  $grpc.ResponseStream<$0.MeterReading> getMeterStream($0.Void request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$getMeterStream, $async.Stream.fromIterable([request]),
        options: options);
  }
}

@$pb.GrpcServiceName('audio_analyser.proto.AudioStreaming')
abstract class AudioStreamingServiceBase extends $grpc.Service {
  $core.String get $name => 'audio_analyser.proto.AudioStreaming';

  AudioStreamingServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Void, $0.AudioBuffer>(
        'GetAudioStream',
        getAudioStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Void.fromBuffer(value),
        ($0.AudioBuffer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Void, $0.MeterReading>(
        'GetMeterStream',
        getMeterStream_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Void.fromBuffer(value),
        ($0.MeterReading value) => value.writeToBuffer()));
  }

  $async.Stream<$0.AudioBuffer> getAudioStream_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Void> request) async* {
    yield* getAudioStream(call, await request);
  }

  $async.Stream<$0.MeterReading> getMeterStream_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Void> request) async* {
    yield* getMeterStream(call, await request);
  }

  $async.Stream<$0.AudioBuffer> getAudioStream(
      $grpc.ServiceCall call, $0.Void request);
  $async.Stream<$0.MeterReading> getMeterStream(
      $grpc.ServiceCall call, $0.Void request);
}

@$pb.GrpcServiceName('audio_analyser.proto.AudioGenerator')
class AudioGeneratorClient extends $grpc.Client {
  static final _$getGeneratorSettings =
      $grpc.ClientMethod<$0.Void, $0.GeneratorSettings>(
          '/audio_analyser.proto.AudioGenerator/GetGeneratorSettings',
          ($0.Void value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GeneratorSettings.fromBuffer(value));
  static final _$setGeneratorSettings =
      $grpc.ClientMethod<$0.GeneratorSettings, $0.Void>(
          '/audio_analyser.proto.AudioGenerator/SetGeneratorSettings',
          ($0.GeneratorSettings value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Void.fromBuffer(value));

  AudioGeneratorClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.GeneratorSettings> getGeneratorSettings(
      $0.Void request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getGeneratorSettings, request, options: options);
  }

  $grpc.ResponseFuture<$0.Void> setGeneratorSettings(
      $0.GeneratorSettings request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setGeneratorSettings, request, options: options);
  }
}

@$pb.GrpcServiceName('audio_analyser.proto.AudioGenerator')
abstract class AudioGeneratorServiceBase extends $grpc.Service {
  $core.String get $name => 'audio_analyser.proto.AudioGenerator';

  AudioGeneratorServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Void, $0.GeneratorSettings>(
        'GetGeneratorSettings',
        getGeneratorSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Void.fromBuffer(value),
        ($0.GeneratorSettings value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GeneratorSettings, $0.Void>(
        'SetGeneratorSettings',
        setGeneratorSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GeneratorSettings.fromBuffer(value),
        ($0.Void value) => value.writeToBuffer()));
  }

  $async.Future<$0.GeneratorSettings> getGeneratorSettings_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Void> request) async {
    return getGeneratorSettings(call, await request);
  }

  $async.Future<$0.Void> setGeneratorSettings_Pre($grpc.ServiceCall call,
      $async.Future<$0.GeneratorSettings> request) async {
    return setGeneratorSettings(call, await request);
  }

  $async.Future<$0.GeneratorSettings> getGeneratorSettings(
      $grpc.ServiceCall call, $0.Void request);
  $async.Future<$0.Void> setGeneratorSettings(
      $grpc.ServiceCall call, $0.GeneratorSettings request);
}
