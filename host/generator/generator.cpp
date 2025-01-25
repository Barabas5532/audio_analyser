#include "generator.h"

void Generator::set_peak_level(float level) { peak_level = level; }

void Generator::set_frequency(float frequency) {
  increment = 2 * (float)M_PI * frequency / *sample_rate;
}

void Generator::set_enable(bool enable) { this->enable = enable; }

void Generator::prepare(const juce::dsp::ProcessSpec &spec) {
  sample_rate = spec.sampleRate;
}

void Generator::process(
    const juce::dsp::ProcessContextReplacing<float> &replacing) {
  auto buffer = replacing.getOutputBlock().getChannelPointer(0);

  if (!enable) {
    replacing.getOutputBlock().clear();
    return;
  }

  for (size_t i = 0; i < replacing.getOutputBlock().getNumSamples(); i++) {
    phase += increment;
    if (phase > 2 * (float)M_PI) {
      phase -= 2 * (float)M_PI;
    }

    buffer[i] = peak_level * sinf(phase);
  }
}

void Generator::reset() { sample_rate = std::nullopt; }
