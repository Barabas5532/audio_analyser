//
//  Generated code. Do not modify.
//  source: juce_embed_gtk.proto
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

import 'juce_embed_gtk.pb.dart' as $0;

export 'juce_embed_gtk.pb.dart';

@$pb.GrpcServiceName('JuceEmbedGtk')
class JuceEmbedGtkClient extends $grpc.Client {
  static final _$setWindowId = $grpc.ClientMethod<$0.WindowId, $0.Void>(
      '/JuceEmbedGtk/SetWindowId',
      ($0.WindowId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Void.fromBuffer(value));
  static final _$getParameter = $grpc.ClientMethod<$0.Void, $0.ParameterValue>(
      '/JuceEmbedGtk/GetParameter',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ParameterValue.fromBuffer(value));
  static final _$setParameter = $grpc.ClientMethod<$0.ParameterValue, $0.Void>(
      '/JuceEmbedGtk/SetParameter',
      ($0.ParameterValue value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Void.fromBuffer(value));

  JuceEmbedGtkClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Void> setWindowId($0.WindowId request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setWindowId, request, options: options);
  }

  $grpc.ResponseFuture<$0.ParameterValue> getParameter($0.Void request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getParameter, request, options: options);
  }

  $grpc.ResponseFuture<$0.Void> setParameter($0.ParameterValue request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setParameter, request, options: options);
  }
}

@$pb.GrpcServiceName('JuceEmbedGtk')
abstract class JuceEmbedGtkServiceBase extends $grpc.Service {
  $core.String get $name => 'JuceEmbedGtk';

  JuceEmbedGtkServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WindowId, $0.Void>(
        'SetWindowId',
        setWindowId_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WindowId.fromBuffer(value),
        ($0.Void value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Void, $0.ParameterValue>(
        'GetParameter',
        getParameter_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Void.fromBuffer(value),
        ($0.ParameterValue value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ParameterValue, $0.Void>(
        'SetParameter',
        setParameter_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ParameterValue.fromBuffer(value),
        ($0.Void value) => value.writeToBuffer()));
  }

  $async.Future<$0.Void> setWindowId_Pre(
      $grpc.ServiceCall call, $async.Future<$0.WindowId> request) async {
    return setWindowId(call, await request);
  }

  $async.Future<$0.ParameterValue> getParameter_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Void> request) async {
    return getParameter(call, await request);
  }

  $async.Future<$0.Void> setParameter_Pre(
      $grpc.ServiceCall call, $async.Future<$0.ParameterValue> request) async {
    return setParameter(call, await request);
  }

  $async.Future<$0.Void> setWindowId(
      $grpc.ServiceCall call, $0.WindowId request);
  $async.Future<$0.ParameterValue> getParameter(
      $grpc.ServiceCall call, $0.Void request);
  $async.Future<$0.Void> setParameter(
      $grpc.ServiceCall call, $0.ParameterValue request);
}

@$pb.GrpcServiceName('AudioStreaming')
class AudioStreamingClient extends $grpc.Client {
  static final _$getAudioStream = $grpc.ClientMethod<$0.Void, $0.AudioBuffer>(
      '/AudioStreaming/GetAudioStream',
      ($0.Void value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AudioBuffer.fromBuffer(value));

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
  }

  $async.Stream<$0.AudioBuffer> getAudioStream_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Void> request) async* {
    yield* getAudioStream(call, await request);
  }

  $async.Stream<$0.AudioBuffer> getAudioStream(
      $grpc.ServiceCall call, $0.Void request);
}
