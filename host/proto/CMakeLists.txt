# Proto file
get_filename_component(proto_file "juce_embed_gtk.proto" ABSOLUTE)
get_filename_component(proto_path "${proto_file}" PATH)

# Generated sources
set(proto_srcs "${CMAKE_CURRENT_BINARY_DIR}/juce_embed_gtk.pb.cc")
set(proto_hdrs "${CMAKE_CURRENT_BINARY_DIR}/juce_embed_gtk.pb.h")
set(grpc_srcs "${CMAKE_CURRENT_BINARY_DIR}/juce_embed_gtk.grpc.pb.cc")
set(grpc_hdrs "${CMAKE_CURRENT_BINARY_DIR}/juce_embed_gtk.grpc.pb.h")
add_custom_command(
        OUTPUT "${proto_srcs}" "${proto_hdrs}" "${grpc_srcs}" "${grpc_hdrs}"
        COMMAND $<TARGET_FILE:protobuf::protoc>
        ARGS --grpc_out "${CMAKE_CURRENT_BINARY_DIR}"
        --cpp_out "${CMAKE_CURRENT_BINARY_DIR}"
        -I "${proto_path}"
        --plugin=protoc-gen-grpc=$<TARGET_FILE:grpc_cpp_plugin>
        "${proto_file}"
        DEPENDS "${proto_file}")

add_library(juce_embed_gtk_proto STATIC)
add_library(juce_embed_gtk::proto ALIAS juce_embed_gtk_proto)

target_include_directories(juce_embed_gtk_proto PUBLIC "${CMAKE_CURRENT_BINARY_DIR}")
target_sources(juce_embed_gtk_proto PRIVATE "${proto_srcs}" "${grpc_srcs}")

target_link_libraries(juce_embed_gtk_proto PUBLIC
                      grpc++
                      grpc++_reflection
                      libprotobuf
)
