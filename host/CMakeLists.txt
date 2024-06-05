cmake_minimum_required(VERSION 3.15)

project(audio_analyser VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK REQUIRED gtk+-3.0)

add_library(gtk3 INTERFACE)
target_link_libraries(gtk3 INTERFACE ${GTK_LIBRARIES})
target_include_directories(gtk3 INTERFACE ${GTK_INCLUDE_DIRS})

add_subdirectory(../third_party third_party)
add_subdirectory(proto)

juce_add_plugin(AudioAnalyser
        PLUGIN_MANUFACTURER_CODE BaRa
        PLUGIN_CODE AuAn
        FORMATS VST3 Standalone
        PRODUCT_NAME "Audio Analyser")

target_sources(AudioAnalyser
        PRIVATE
        audio_queue.cpp
        plugin_editor.cpp
        plugin_processor.cpp
        grpc_server_thread.cpp
        )

target_compile_definitions(AudioAnalyser
        PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0)

target_link_libraries(AudioAnalyser
        PRIVATE
        juce::juce_audio_utils
        gtk3
        audio_analyser::proto
        SPSCQueue::SPSCQueue
        PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)