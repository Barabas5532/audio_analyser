#pragma once

#include "plugin_processor.h"
#include <juce_gui_extra/juce_gui_extra.h>

//==============================================================================
class AudioPluginAudioProcessorEditor : public juce::AudioProcessorEditor {
public:
  explicit AudioPluginAudioProcessorEditor(AudioAnalyserAudioProcessor &);
  ~AudioPluginAudioProcessorEditor() override;

  //==============================================================================
  void paint(juce::Graphics &) override;
  void resized() override;

private:
  // This reference is provided as a quick way for your editor to
  // access the processor object that created it.
  AudioAnalyserAudioProcessor &processorRef;

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  juce::XEmbedComponent embeddedComponent;
#endif

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(AudioPluginAudioProcessorEditor)
};
