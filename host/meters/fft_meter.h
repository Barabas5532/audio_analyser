#pragma once

#include "meter.h"

namespace internal {
static constexpr std::size_t FFT_ORDER = 11;
static constexpr std::size_t FFT_SIZE = 1 << FFT_ORDER;
} // namespace internal

struct FftReading {
  float sample_rate;
  std::array<float, internal::FFT_SIZE> magnitudes;
};

class FftMeter final : public Meter<FftReading> {
public:
  void prepare(const juce::dsp::ProcessSpec &spec) override;
  void
  process(const juce::dsp::ProcessContextReplacing<float> &replacing) override;
  void reset() override;

  [[nodiscard]] FftReading get_reading() const override;

private:
  void push_next_sample_into_fifo(float sample) noexcept;
  
  float sample_rate;
  
  std::atomic<FftReading> reading;

  juce::dsp::FFT fft{internal::FFT_ORDER};
  juce::dsp::WindowingFunction<float> window{
      internal::FFT_SIZE,
      juce::dsp::WindowingFunction<float>::blackmanHarris,
  };

  std::array<float, internal::FFT_SIZE> fifo{};
  std::array<float, 2 * internal::FFT_SIZE> fftData{};
  size_t fifo_index{0};
};