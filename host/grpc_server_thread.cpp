#include "grpc_server_thread.h"
#include "audio_analyser.grpc.pb.h"
#include "audio_queue.h"
#include "plugin_processor.h"
#include <grpcpp/server_builder.h>

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
#include <cinttypes>
#endif

#if AUDIO_ANALYSER_ENABLE_EMBEDDING
class AudioAnalyserImpl final : public AudioAnalyser::Service {
public:
  explicit AudioAnalyserImpl(AudioAnalyserAudioProcessor &a_processor)
      : processor{a_processor} {};

  grpc::Status SetWindowId(::grpc::ServerContext *context,
                           const ::WindowId *request,
                           ::Void *response) override {
    juce::Logger::outputDebugString(
        juce::String::formatted("Set window ID %" PRIu64, request->id()));

    processor.wId = request->id();
    processor.wId.notify_all();

    return grpc::Status::OK;
  }

private:
  AudioAnalyserAudioProcessor &processor;
};
#endif

class AudioStreamingImpl final : public AudioStreaming::CallbackService,
                                 private juce::Timer {
public:
  explicit AudioStreamingImpl(AudioQueue &a_queue) : queue{a_queue} {
    startTimerHz(100);
  }

  ::grpc::ServerWriteReactor<::AudioBuffer> *
  GetAudioStream(::grpc::CallbackServerContext *context,
                 const ::Void *request) {
    class Reactor : public grpc::ServerWriteReactor<::AudioBuffer> {
    public:
      Reactor(AudioQueue &a_queue, std::mutex &a_callback_mutex,
              std::optional<std::function<void()>> &a_callback)
          : queue{a_queue}, callback_mutex{a_callback_mutex},
            callback{a_callback} {
        // TODO add support for multiple clients
        // register thread safe queue stream with the audio app at runtime
        //
        // This version uses a single hardcoded audio sample queue, that works
        // as long as there is a only a single audio stream running at once.

        juce::Logger::outputDebugString("New GetAudioStream starting");
        
        queue.reset();
        
        NextWrite();
      }

      void OnDone() override {
        juce::Logger::outputDebugString("Reactor OnDone");
        delete this;
      }

      void OnWriteDone(bool /*ok*/) override { NextWrite(); }

      void OnCancel() override {
        juce::Logger::outputDebugString("Reactor OnCancel");
        is_cancelled = true;
      }

    private:
      void NextWrite() {
        if (is_cancelled) {
          Finish(grpc::Status::CANCELLED);
          return;
        }

        {
          std::scoped_lock lock{callback_mutex};

          callback = [this]() {
            message = ::AudioBuffer();
            float sample;
            while (this->queue.pop(sample)) {
              message.add_samples(sample);
            }
            this->StartWrite(&message);
          };
        }
      }

      AudioBuffer message;
      AudioQueue &queue;
      std::mutex &callback_mutex;
      std::optional<std::function<void()>> &callback;
      bool is_cancelled = false;
    };

    return new Reactor(queue, callback_mutex, callback);
  }

private:
  void timerCallback() override {
    std::scoped_lock lock{callback_mutex};

    if (callback.has_value()) {
      (*callback)();
      // Wait until OnWriteDone reaction before calling back again. We may end
      // up dropping buffers if a write takes longer than the timer period, but
      // it's preferrable to crashing.
      callback = nullptr;
    }
  }

  AudioQueue &queue;
  std::mutex callback_mutex;
  std::optional<std::function<void()>> callback;
};

void GrpcServerThread::run() {
  auto audio_streaming_service = AudioStreamingImpl{processor.queue};

  // TODO CMake config for port
  std::string server_address{"localhost:8080"};
  int port = 0;

  grpc::ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials(),
                           &port);
#if AUDIO_ANALYSER_ENABLE_EMBEDDING
  auto service = AudioAnalyserImpl{processor};
  builder.RegisterService(&service);
#endif
  builder.RegisterService(&audio_streaming_service);
  std::unique_ptr<grpc::Server> server{builder.BuildAndStart()};

  juce::Logger::outputDebugString(
      juce::String::formatted("gRPC server started on port %d", port));
  processor.grpc_server_port = port;
  processor.grpc_server_port.notify_all();
  server->Wait();
  juce::Logger::outputDebugString("gRPC server finished");
}

GrpcServerThread::GrpcServerThread(AudioAnalyserAudioProcessor &a_processor)
    : Thread("grpc"), processor{a_processor} {}
