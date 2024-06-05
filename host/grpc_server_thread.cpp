#include "grpc_server_thread.h"
#include "audio_queue.h"
#include "juce_embed_gtk.grpc.pb.h"
#include "plugin_processor.h"
#include <cinttypes>
#include <grpcpp/server_builder.h>

class JuceEmbedGtkImpl final : public JuceEmbedGtk::Service {
public:
  explicit JuceEmbedGtkImpl(AudioPluginAudioProcessor &a_processor)
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

  grpc::Status GetParameter(::grpc::ServerContext *context,
                            const ::Void *request,
                            ::ParameterValue *response) override {
    juce::Logger::outputDebugString("Get parameter");
    response->set_value(*processor.parameters.getRawParameterValue("gain"));

    return grpc::Status::OK;
  }

  grpc::Status SetParameter(::grpc::ServerContext *context,
                            const ::ParameterValue *request,
                            ::Void *response) override {
    juce::Logger::outputDebugString(
        juce::String::formatted("Set parameter %f", request->value()));

    processor.parameters.getParameter("gain")->setValueNotifyingHost(
        request->value());

    return grpc::Status::OK;
  }

private:
  AudioPluginAudioProcessor &processor;
};

class AudioStreamingImpl final : public AudioStreaming::Service,
                                 private juce::Timer {
public:
  explicit AudioStreamingImpl(AudioQueue &a_queue) : queue{a_queue}  { startTimerHz(100); }

  grpc::Status
  GetAudioStream(::grpc::ServerContext *context, const ::Void *request,
                 ::grpc::ServerWriter<::AudioBuffer> *writer) override {
    // TODO add support for multiple clients
    // register thread safe queue stream with the audio app at runtime
    // 
    // This version uses a single hardcoded audio sample queue, that works as
    // long as there is a only a single audio stream running at once.

    int state_copy = 0;
    {
      std::lock_guard lock{mutex};
      state_copy = state;
    }

    queue.reset();

    while (true) {
      {
        std::unique_lock lock{mutex};
        cv.wait(lock, [&]() -> bool {
          if (state_copy == state) {
            // spurious wakeup
            return false;
          }

          state_copy = state;
          return true;
        });
      }

      auto message = ::AudioBuffer();
      float sample;
      while (queue.pop(sample)) {
        message.add_samples(sample);
      }

      writer->Write(message);
    }
  }

private:
  void timerCallback() override {
    // trigger polling of the buffer
    std::lock_guard lock{mutex};
    state++;
    cv.notify_all();
  }

  std::mutex mutex;
  std::condition_variable cv;
  int state{};

  AudioQueue &queue;
};

void GrpcServerThread::run() {
  auto service = JuceEmbedGtkImpl{processor};
  auto audio_streaming_service = AudioStreamingImpl{processor.queue};

  std::string server_address{"localhost:0"};
  int port = 0;

  grpc::ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials(),
                           &port);
  builder.RegisterService(&service);
  builder.RegisterService(&audio_streaming_service);
  auto cq = builder.AddCompletionQueue();
  auto server = builder.BuildAndStart();

  juce::Logger::outputDebugString(
      juce::String::formatted("gRPC server started on port %d", port));
  processor.grpc_server_port = port;
  processor.grpc_server_port.notify_all();
  server->Wait();
  juce::Logger::outputDebugString("gRPC server finished");
}

GrpcServerThread::GrpcServerThread(AudioPluginAudioProcessor &a_processor)
    : Thread("grpc"), processor{a_processor} {}
