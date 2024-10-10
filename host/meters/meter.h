#include "juce_dsp/juce_dsp.h"

class MeterBase : public juce::dsp::ProcessorBase {
public: 
  /// Get the meter reading in meter specific units
  virtual float get_reading() = 0;
};