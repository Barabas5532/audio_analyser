#pragma once

#include "audio_queue.h"
#include "generator/generator.h"
#include "grpc_server_thread.h"
#include "meters/meter_reading.h"
#include "meters/rms_meter.h"
#include <juce_audio_processors/juce_audio_processors.h>

//==============================================================================
class AudioAnalyserAudioProcessor final : public juce::AudioProcessor {
public:
  //==============================================================================
  AudioAnalyserAudioProcessor();
  ~AudioAnalyserAudioProcessor() override = default;

  //==============================================================================
  void prepareToPlay(double sampleRate, int samplesPerBlock) override;
  void releaseResources() override;

  bool isBusesLayoutSupported(const BusesLayout &layouts) const override;

  void processBlock(juce::AudioBuffer<float> &, juce::MidiBuffer &) override;
  using AudioProcessor::processBlock;

  //==============================================================================
  juce::AudioProcessorEditor *createEditor() override;
  bool hasEditor() const override;

  //==============================================================================
  const juce::String getName() const override;

  bool acceptsMidi() const override;
  bool producesMidi() const override;
  bool isMidiEffect() const override;
  double getTailLengthSeconds() const override;

  //==============================================================================
  int getNumPrograms() override;
  int getCurrentProgram() override;
  void setCurrentProgram(int index) override;
  const juce::String getProgramName(int index) override;
  void changeProgramName(int index, const juce::String &newName) override;

  //==============================================================================
  void getStateInformation(juce::MemoryBlock &destData) override;
  void setStateInformation(const void *data, int sizeInBytes) override;
  
  MeterReading getMeterReading();

private:
  juce::AudioProcessorValueTreeState parameters;

  GrpcServerThread server_thread;
  std::atomic<int> grpc_server_port;
  juce::ChildProcess gui_process;
  AudioQueue queue;
  
  juce::dsp::ProcessorChain<RmsMeter, FftMeter> meter_chain;
  const RmsMeter &rms_meter;
  const FftMeter &fft_meter;

  Generator generator;

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  std::atomic<unsigned long> wId;
#endif

  std::atomic<float>* generator_enabled;
  std::atomic<float>* generator_level;
  std::atomic<float>* generator_frequency; 
  
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(AudioAnalyserAudioProcessor)

  // Accesses the parameters member to notify the processor about parameter
  // updates by the frontend. The grpc thread is the only writer of parameters.
  friend class GrpcServerThread;
};
