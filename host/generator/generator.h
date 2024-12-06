#include "juce_dsp/juce_dsp.h"

/** Generates a test tone.
 * 
 * Ignores input signal and generates an output signal according to the peak
 * level, frequency and enable parameters.
 */
class Generator final : public juce::dsp::ProcessorBase {
public:
  void set_peak_level(float level);
  void set_frequency(float frequency);
  void set_enable(bool enable);

  void prepare(const juce::dsp::ProcessSpec &spec) override;
  void
  process(const juce::dsp::ProcessContextReplacing<float> &replacing) override;
  void reset() override;
  
private:
  std::optional<float> sample_rate = std::nullopt;

  float phase = 0;
  
  float peak_level = 0;
  float increment = 0;
  bool enable = false;
};