#pragma once

#include "fft_meter.h"

struct MeterReading {
  float rms;
  FftReading fft;
};