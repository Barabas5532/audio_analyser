#include "rms_meter.h"


float RmsMeter::get_reading() { return reading; }

void RmsMeter::prepare(const juce::dsp::ProcessSpec &spec) {}

void RmsMeter::process(
    const juce::dsp::ProcessContextReplacing<float> &context) {
      // TODO change API so that only single channel can be sent to mono
      // analyzers
      //
      // Handle multi-channel at a higher level of abstraction
    
      // TODO implement a reading rate parameter, buffer audio and update
      // reading at the specified rate.
    
      const float *buffer = context.getInputBlock().getChannelPointer(0);
      auto size = context.getInputBlock().getNumSamples();
      float accum = 0;
      for(int i = 0; i < size ; i++) {
        accum += buffer[i] * buffer[i];
      }
      
      reading = std::sqrt(accum / size);
    }
    
void RmsMeter::reset() {}
