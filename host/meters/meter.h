#pragma once

#include "juce_dsp/juce_dsp.h"

template <typename T>
class Meter : public juce::dsp::ProcessorBase {
public: 
  /// Get the meter reading in meter specific units
  [[nodiscard]] virtual T get_reading() const = 0;
};