#include "fft_meter.h"
#include <cassert>

void FftMeter::prepare(const juce::dsp::ProcessSpec &spec) {
  this->sample_rate = spec.sampleRate;
}

void FftMeter::process(
    const juce::dsp::ProcessContextReplacing<float> &context) {
  assert(context.getInputBlock() == context.getOutputBlock());

  if (context.getInputBlock().getNumChannels() > 0) {
    auto *channelData = context.getInputBlock().getChannelPointer(0);

    for (size_t i = 0; i < context.getInputBlock().getNumSamples(); ++i)
      push_next_sample_into_fifo(channelData[i]);
  }
}

void FftMeter::push_next_sample_into_fifo(float sample) noexcept {
  if (fifo_index == internal::FFT_SIZE) {
    juce::zeromem(fftData.data(), sizeof(float) * fftData.size());
    std::memcpy(fftData.data(), fifo.data(), sizeof(float) * fifo.size());

    window.multiplyWithWindowingTable(fftData.data(), internal::FFT_SIZE);
    fft.performFrequencyOnlyForwardTransform(fftData.data());

    fifo_index = 0;

    FftReading reading{
        .sample_rate{this->sample_rate},
        .magnitudes{},
    };
    memcpy(reading.magnitudes.data(), fftData.data(), internal::FFT_SIZE);

    this->reading = reading;
  }

  fifo[fifo_index++] = sample;
}

void FftMeter::reset() { fifo_index = 0; }

FftReading FftMeter::get_reading() const { return reading; }
