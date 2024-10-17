#include "juce_dsp/juce_dsp.h"

class MeterBase : public juce::dsp::ProcessorBase {
public: 
  /// Get the meter reading in meter specific units
  [[nodiscard]] virtual float get_reading() const = 0;
};