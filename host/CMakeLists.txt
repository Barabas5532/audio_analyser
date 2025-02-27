cmake_minimum_required(VERSION 3.15)

project(audio_analyser VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

add_subdirectory(../third_party third_party)
add_subdirectory(proto)

add_library(compiler_flags INTERFACE)
target_compile_options(compiler_flags INTERFACE -Werror=missing-field-initializers)

juce_add_plugin(AudioAnalyser
        PLUGIN_MANUFACTURER_CODE BaRa
        PLUGIN_CODE AuAn
        FORMATS VST3 Standalone
        PRODUCT_NAME "Audio Analyser")

target_sources(AudioAnalyser
        PRIVATE
        audio_queue.cpp
        plugin_editor.cpp
        meters/rms_meter.cpp
        meters/fft_meter.cpp
        generator/generator.cpp
        plugin_processor.cpp
        grpc_server_thread.cpp
        )

target_compile_definitions(AudioAnalyser
        PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        AUDIO_ANALYSER_ENABLE_EMBEDDING=0
)

target_link_libraries(AudioAnalyser
        PRIVATE
        atomic
        SPSCQueue::SPSCQueue
        audio_analyser::proto
        compiler_flags
        juce::juce_dsp
        juce::juce_audio_utils
        PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
