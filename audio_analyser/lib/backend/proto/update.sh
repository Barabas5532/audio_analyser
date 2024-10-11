#!/usr/bin/env bash

rm generated/*.dart
protoc --dart_out=grpc:generated -I../../../../host/proto ../../../../host/proto/audio_analyser.proto

dart format generated