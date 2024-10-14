#pragma once

#include <juce_core/juce_core.h>

class AudioAnalyserAudioProcessor;

class GrpcServerThread : public juce::Thread {
public:
  explicit GrpcServerThread(AudioAnalyserAudioProcessor &processor);

private:
  void run() override;
  AudioAnalyserAudioProcessor &processor;
};