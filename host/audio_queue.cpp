
#include "audio_queue.h"

AudioQueue::AudioQueue() : queue(192000) {}

void AudioQueue::push(float sample) { queue.try_push(sample); }

bool AudioQueue::pop(float &sample) {
  if (queue.empty()) {
    return false;
  }
  
  sample = *queue.front();
  queue.pop();
  return true;
}

void AudioQueue::reset() {
  while(!queue.empty()) queue.pop();
}
