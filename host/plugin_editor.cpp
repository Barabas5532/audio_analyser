#include "plugin_editor.h"
#include "plugin_processor.h"

//==============================================================================
AudioPluginAudioProcessorEditor::AudioPluginAudioProcessorEditor(
    AudioAnalyserAudioProcessor &p)
    : AudioProcessorEditor(&p), processorRef(p)
#if AUDIO_ANALYSER_ENABLE_EMBEDDING
      ,
      embeddedComponent(atomic_load(&this->processorRef.wId))
#endif
{
  juce::Logger::writeToLog("Constructing editor");

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  addAndMakeVisible(&embeddedComponent);
#endif

  // Make sure that before the constructor has finished, you've set the
  // editor's size to whatever you need it to be.
  setSize(400, 300);
}

AudioPluginAudioProcessorEditor::~AudioPluginAudioProcessorEditor() {}

//==============================================================================
void AudioPluginAudioProcessorEditor::paint(juce::Graphics &g) {
  // (Our component is opaque, so we must completely fill the background with a
  // solid colour)
  g.fillAll(
      getLookAndFeel().findColour(juce::ResizableWindow::backgroundColourId));
}

void AudioPluginAudioProcessorEditor::resized() {
#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  embeddedComponent.setBounds(getLocalBounds());
#endif
}
