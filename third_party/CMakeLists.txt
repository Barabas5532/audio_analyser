add_subdirectory(JUCE)
add_subdirectory(SPSCQueue)

# Work around issue during cmake configure:
# https://github.com/protocolbuffers/protobuf/issues/12185
set(protobuf_INSTALL OFF)
set(utf8_range_ENABLE_INSTALL OFF)

add_subdirectory(grpc EXCLUDE_FROM_ALL)