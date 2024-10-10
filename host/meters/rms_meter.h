#pragma once

#include "meter.h"

class RmsMeter : public MeterBase {
public:
  float get_reading() override;
  void prepare(const juce::dsp::ProcessSpec &spec) override;
  void
  process(const juce::dsp::ProcessContextReplacing<float> &context) override;
  void reset() override;

private:
  std::atomic<float> reading;
};
