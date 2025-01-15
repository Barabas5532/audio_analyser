#include "plugin_processor.h"
#include "plugin_editor.h"

//==============================================================================
AudioAnalyserAudioProcessor::AudioAnalyserAudioProcessor()
    : AudioProcessor(
          BusesProperties()
#if !JucePlugin_IsMidiEffect
#if !JucePlugin_IsSynth
              .withInput("Input", juce::AudioChannelSet::stereo(), true)
#endif
              .withOutput("Output", juce::AudioChannelSet::stereo(), true)
#endif
              ),
      server_thread(*this), rms_meter{meter_chain.get<0>()},
      parameters(
          *this, nullptr, "analyser",
          {std::make_unique<juce::AudioParameterBool>("gen_enable",
                                                      "Generator Enable", true),
           std::make_unique<juce::AudioParameterFloat>(
               "gen_level", "Generator Level", 0.f, 1.f, 0.5f),
           std::make_unique<juce::AudioParameterFloat>(
               "gen_frequency", "Generator Frequency", 1.f, 20000.f, 1000.f)}) {
  generator_enabled = parameters.getRawParameterValue("gen_enable");
  generator_level = parameters.getRawParameterValue("gen_level");
  generator_frequency = parameters.getRawParameterValue("gen_frequency");

  server_thread.startThread();

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  auto current_path = juce::File::getSpecialLocation(
      juce::File::SpecialLocationType::currentExecutableFile);
  juce::Logger::writeToLog("current path: " + current_path.getFullPathName());

  auto path = current_path.getSiblingFile("audio_analyser");

  // XXX: Need to copy the flutter app executable here manually for now
  juce::Logger::writeToLog("path to embedded: " + path.getFullPathName());

  // wait for server to pick a port to run on
  grpc_server_port.wait(0);
  auto gui_success = gui_process.start(juce::StringArray{
      path.getFullPathName(),
      juce::String::formatted("%d", grpc_server_port.load())});
  jassert(gui_success);

  // Must wait here for the wID to avoid race condition where editor is created
  // before it is set.
  wId.wait(0);
  juce::Logger::writeToLog("Got wId, returning from constructor");
#endif
}

//==============================================================================
const juce::String AudioAnalyserAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool AudioAnalyserAudioProcessor::acceptsMidi() const {
#if JucePlugin_WantsMidiInput
  return true;
#else
  return false;
#endif
}

bool AudioAnalyserAudioProcessor::producesMidi() const {
#if JucePlugin_ProducesMidiOutput
  return true;
#else
  return false;
#endif
}

bool AudioAnalyserAudioProcessor::isMidiEffect() const {
#if JucePlugin_IsMidiEffect
  return true;
#else
  return false;
#endif
}

double AudioAnalyserAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int AudioAnalyserAudioProcessor::getNumPrograms() {
  return 1; // NB: some hosts don't cope very well if you tell them there are 0
            // programs,
  // so this should be at least 1, even if you're not really implementing
  // programs.
}

int AudioAnalyserAudioProcessor::getCurrentProgram() { return 0; }

void AudioAnalyserAudioProcessor::setCurrentProgram(int index) {
  juce::ignoreUnused(index);
}

const juce::String AudioAnalyserAudioProcessor::getProgramName(int index) {
  juce::ignoreUnused(index);
  return {};
}

void AudioAnalyserAudioProcessor::changeProgramName(
    int index, const juce::String &newName) {
  juce::ignoreUnused(index, newName);
}

//==============================================================================
void AudioAnalyserAudioProcessor::prepareToPlay(double sampleRate,
                                                int samplesPerBlock) {
  auto spec = juce::dsp::ProcessSpec{
      .sampleRate{sampleRate},
      .maximumBlockSize{static_cast<juce::uint32>(samplesPerBlock)},
      .numChannels{static_cast<juce::uint32>(getTotalNumInputChannels())},
  };
  
  meter_chain.prepare(spec);
  generator.prepare(spec);
}

void AudioAnalyserAudioProcessor::releaseResources() {
  meter_chain.reset();
  generator.reset();
}

bool AudioAnalyserAudioProcessor::isBusesLayoutSupported(
    const BusesLayout &layouts) const {
#if JucePlugin_IsMidiEffect
  juce::ignoreUnused(layouts);
  return true;
#else
  // This is the place where you check if the layout is supported.
  // In this template code we only support mono or stereo.
  // Some plugin hosts, such as certain GarageBand versions, will only
  // load plugins that support stereo bus layouts.
  if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono() &&
      layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
    return false;

  // This checks if the input layout matches the output layout
#if !JucePlugin_IsSynth
  if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
    return false;
#endif

  return true;
#endif
}

void AudioAnalyserAudioProcessor::processBlock(juce::AudioBuffer<float> &buffer,
                                               juce::MidiBuffer &) {
  juce::ScopedNoDenormals noDenormals;

  auto samples = buffer.getReadPointer(0);
  for (int i = 0; i < buffer.getNumSamples(); i++) {
    queue.push(samples[i]);
  }

  auto block = juce::dsp::AudioBlock<float>{buffer};
  auto process_context = juce::dsp::ProcessContextReplacing(block);

  meter_chain.process(process_context);
  
  // Process the generator last as it overwrites the buffer contents with the
  // generated signal.
  generator.set_enable(*generator_enabled > 0.5f);
  generator.set_peak_level(*generator_level);
  generator.set_frequency(*generator_frequency);
  
  generator.process(process_context);
}

//==============================================================================
bool AudioAnalyserAudioProcessor::hasEditor() const {
  return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor *AudioAnalyserAudioProcessor::createEditor() {
  return new AudioPluginAudioProcessorEditor(*this);
}

//==============================================================================
void AudioAnalyserAudioProcessor::getStateInformation(
    juce::MemoryBlock &destData) {
  // You should use this method to store your parameters in the memory block.
  // You could do that either as raw data, or use the XML or ValueTree classes
  // as intermediaries to make it easy to save and load complex data.
  juce::ignoreUnused(destData);
}

void AudioAnalyserAudioProcessor::setStateInformation(const void *data,
                                                      int sizeInBytes) {
  // You should use this method to restore your parameters from this memory
  // block, whose contents will have been created by the getStateInformation()
  // call.
  juce::ignoreUnused(data, sizeInBytes);
}

MeterReading AudioAnalyserAudioProcessor::getMeterReading() {
  return MeterReading{.rms{rms_meter.get_reading()}};
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor *JUCE_CALLTYPE createPluginFilter() {
  return new AudioAnalyserAudioProcessor();
}
