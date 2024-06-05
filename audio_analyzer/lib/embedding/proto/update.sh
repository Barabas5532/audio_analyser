#!/usr/bin/env bash

rm generated/*.dart
protoc --dart_out=grpc:generated -I../../../plugin/proto ../../../plugin/proto/juce_embed_gtk.proto

dart format generated