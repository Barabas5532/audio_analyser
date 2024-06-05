#pragma once

#include <juce_core/juce_core.h>

class AudioPluginAudioProcessor;

class GrpcServerThread : public juce::Thread {
public:
  explicit GrpcServerThread(AudioPluginAudioProcessor &processor);

private:
  void run() override; 
  AudioPluginAudioProcessor &processor;
};