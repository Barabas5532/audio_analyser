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

class AudioStreamingImpl final
    : public audio_analyser::proto::AudioStreaming::CallbackService,
      private juce::Timer {
public:
  explicit AudioStreamingImpl(AudioQueue &queue,
                              std::function<MeterReading()> &get_meter_reading)
      : queue{queue}, get_meter_reading{get_meter_reading} {
    startTimerHz(100);
  }

  ::grpc::ServerWriteReactor<audio_analyser::proto::AudioBuffer> *
  GetAudioStream(::grpc::CallbackServerContext *context,
                 const audio_analyser::proto::Void *request) override {
    class Reactor
        : public grpc::ServerWriteReactor<audio_analyser::proto::AudioBuffer> {
    public:
      Reactor(AudioQueue &queue, std::mutex &callback_mutex,
              std::optional<std::function<void()>> &callback)
          : queue{queue}, callback_mutex{callback_mutex}, callback{callback} {
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
        {
          std::scoped_lock lock{callback_mutex};
          callback = std::nullopt;
        }
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
            auto message = audio_analyser::proto::AudioBuffer();
            float sample;
            while (this->queue.pop(sample)) {
              message.add_samples(sample);
            }
            this->StartWrite(&message);
          };
        }
      }

      AudioQueue &queue;
      std::mutex &callback_mutex;
      std::optional<std::function<void()>> &callback;
      bool is_cancelled = false;
    };

    return new Reactor(queue, callback_mutex, callback);
  }

  ::grpc::ServerWriteReactor<::audio_analyser::proto::MeterReading> *
  GetMeterStream(::grpc::CallbackServerContext *,
                 const ::audio_analyser::proto::Void *) override {
    class Reactor
        : public grpc::ServerWriteReactor<audio_analyser::proto::MeterReading> {
    public:
      Reactor(std::function<MeterReading()> &get_meter_reading,
              std::mutex &callback_mutex,
              std::optional<std::function<void()>> &callback)
          : get_meter_reading{get_meter_reading},
            callback_mutex{callback_mutex}, callback{callback} {
        juce::Logger::outputDebugString("New GetMeterStream starting");

        NextWrite();
      }

      void OnDone() override {
        juce::Logger::outputDebugString("Reactor OnDone");
        {
          std::scoped_lock lock{callback_mutex};
          callback = std::nullopt;
        }
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
            auto meter_reading = get_meter_reading();
            auto message = audio_analyser::proto::MeterReading();
            message.set_rms(meter_reading.rms);
            float sample;
            this->StartWrite(&message);
          };
        }
      }

      std::function<MeterReading()> &get_meter_reading;
      std::mutex &callback_mutex;
      std::optional<std::function<void()>> &callback;
      bool is_cancelled = false;
    };

    return new Reactor(get_meter_reading, callback2_mutex, callback2);
  }

private:
  void timerCallback() override {
    {
      std::scoped_lock lock{callback_mutex};

      if (callback.has_value()) {
        (*callback)();
        // Wait until OnWriteDone reaction before calling back again. We may end
        // up dropping buffers if a write takes longer than the timer period,
        // but it's preferable to crashing.
        callback = std::nullopt;
      }
    }

    {
      std::scoped_lock lock{callback2_mutex};

      if (callback2.has_value()) {
        (*callback2)();
        callback2 = std::nullopt;
      }
    }
  }

  AudioQueue &queue;
  std::function<MeterReading()> &get_meter_reading;

  std::mutex callback_mutex;
  std::optional<std::function<void()>> callback;

  std::mutex callback2_mutex;
  std::optional<std::function<void()>> callback2;
};

void GrpcServerThread::run() {
  auto get_meter_reading = std::function<MeterReading()>{
      [p = &processor] { return p->getMeterReading(); }};
  auto audio_streaming_service =
      AudioStreamingImpl{processor.queue, get_meter_reading};

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
