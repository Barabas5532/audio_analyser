# Proto file
get_filename_component(proto_file "audio_analyser.proto" ABSOLUTE)
get_filename_component(proto_path "${proto_file}" PATH)

# Generated sources
set(proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/audio_analyser.pb.cc")
set(proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/audio_analyser.pb.h")
set(grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/audio_analyser.grpc.pb.cc")
set(grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/audio_analyser.grpc.pb.h")
add_custom_command(
        OUTPUT "${proto_srcs}" "${proto_hdrs}" "${grpc_srcs}" "${grpc_hdrs}"
        COMMAND $<TARGET_FILE:protobuf::protoc>
        ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${proto_path}"
        --plugin=protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>
        "${proto_file}"
        DEPENDS "${proto_file}")

add_library(audio_analyser_proto STATIC)
add_library(audio_analyser::proto ALIAS audio_analyser_proto)

target_include_directories(audio_analyser_proto PUBLIC "${CMAKE_CURRENT_BINARY_DIR}")
target_sources(audio_analyser_proto PRIVATE "${proto_srcs}" "${grpc_srcs}")

target_link_libraries(audio_analyser_proto PUBLIC
                      grpc++
                      grpc++_reflection
                      libprotobuf
)
