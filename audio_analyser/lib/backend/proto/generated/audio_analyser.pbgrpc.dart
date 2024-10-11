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

@$pb.GrpcServiceName('AudioAnalyser')
class AudioAnalyserClient extends $grpc.Client {
  static final _$setWindowId = $grpc.ClientMethod<$0.WindowId, $0.Void>(
      '/AudioAnalyser/SetWindowId',
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

@$pb.GrpcServiceName('AudioAnalyser')
abstract class AudioAnalyserServiceBase extends $grpc.Service {
  $core.String get $name => 'AudioAnalyser';

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

@$pb.GrpcServiceName('AudioStreaming')
class AudioStreamingClient extends $grpc.Client {
  static final _$getAudioStream = $grpc.ClientMethod<$0.Void, $0.AudioBuffer>(
      '/AudioStreaming/GetAudioStream',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AudioBuffer.fromBuffer(value));
  static final _$getMeterStream = $grpc.ClientMethod<$0.Void, $0.MeterReading>(
      '/AudioStreaming/GetMeterStream',
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

@$pb.GrpcServiceName('AudioStreaming')
abstract class AudioStreamingServiceBase extends $grpc.Service {
  $core.String get $name => 'AudioStreaming';

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
