#pragma once

#include "rigtorp/SPSCQueue.h"

class AudioQueue {
public:
  AudioQueue();

  void push(float sample);
  
  bool pop(float &sample); 
  
  void reset();
private:
  rigtorp::SPSCQueue<float> queue;
};