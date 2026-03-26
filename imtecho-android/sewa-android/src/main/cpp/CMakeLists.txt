cmake_minimum_required(VERSION 3.22)
project(medwhisper)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#set(WHISPER_DIR ${CMAKE_SOURCE_DIR}/whisper)
#set(GGML_DIR ${WHISPER_DIR}/ggml)
#
## Whisper sources
#set(WHISPER_SRCS "")
#if (EXISTS ${WHISPER_DIR}/whisper.cpp)
#    list(APPEND WHISPER_SRCS ${WHISPER_DIR}/whisper.cpp)
#elseif (EXISTS ${WHISPER_DIR}/src/whisper.cpp)
#    list(APPEND WHISPER_SRCS ${WHISPER_DIR}/src/whisper.cpp)
#else()
#    message(FATAL_ERROR "Could not find whisper.cpp sources")
#endif()
#
#
#file(GLOB GGML_CPU_SRCS
#        ${GGML_DIR}/src/ggml-cpu/*.c
#        ${GGML_DIR}/src/ggml-cpu/*.cpp
#        ${GGML_DIR}/src/ggml-cpu/arch/arm/*.c
#        ${GGML_DIR}/src/ggml-cpu/arch/arm/*.cpp
#)
#
#
#set(GGML_SRCS
#        ${GGML_DIR}/src/ggml.c
#        ${GGML_DIR}/src/ggml.cpp
#        ${GGML_DIR}/src/ggml-alloc.c
#        ${GGML_DIR}/src/ggml-backend.cpp
#        ${GGML_DIR}/src/ggml-backend-reg.cpp
#        ${GGML_DIR}/src/ggml-threading.cpp
#        ${GGML_DIR}/src/ggml-opt.cpp
#        ${GGML_DIR}/src/ggml-quants.c
#        ${GGML_DIR}/src/gguf.cpp
#        ${GGML_DIR}/src/ggml-cpu/binary-ops.cpp
#        ${GGML_DIR}/src/ggml-cpu/ggml-cpu.c
#        ${GGML_DIR}/src/ggml-cpu/ggml-cpu.cpp
#        ${GGML_DIR}/src/ggml-cpu/hbm.cpp
#        ${GGML_DIR}/src/ggml-cpu/ops.cpp
#        ${GGML_DIR}/src/ggml-cpu/quants.c
#        ${GGML_DIR}/src/ggml-cpu/repack.cpp
#        ${GGML_DIR}/src/ggml-cpu/traits.cpp
#        ${GGML_DIR}/src/ggml-cpu/unary-ops.cpp
#        ${GGML_DIR}/src/ggml-cpu/vec.cpp
#        ${GGML_CPU_SRCS}
#)
#
## Build whisper lib
#add_library(medwhisper SHARED
#        ${WHISPER_SRCS}
#        ${GGML_SRCS}
#        ${CMAKE_SOURCE_DIR}/medwhisper.cpp
#)
#
#target_include_directories(medwhisper PRIVATE
#        ${WHISPER_DIR}
#        ${WHISPER_DIR}/include
#        ${GGML_DIR}/include
#        ${GGML_DIR}/src
#        ${GGML_DIR}/src/ggml-cpu
#)
#
#execute_process(
#        COMMAND git rev-parse --short HEAD
#        WORKING_DIRECTORY ${GGML_DIR}
#        OUTPUT_VARIABLE GGML_GIT_COMMIT
#        OUTPUT_STRIP_TRAILING_WHITESPACE
#)
#target_compile_definitions(medwhisper PRIVATE
#        GGML_USE_CPU
#        WHISPER_VERSION=\"custom-build\"
#        GGML_VERSION=\"custom-build\"
#        GGML_COMMIT=\"${GGML_GIT_COMMIT}\"
#)
#
#
#if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
#    target_compile_options(medwhisper PRIVATE
#            -O3 -ffunction-sections -fdata-sections
#            -fvisibility=hidden -fvisibility-inlines-hidden
#    )
#    target_link_options(medwhisper PRIVATE
#            -Wl,--gc-sections -Wl,--exclude-libs,ALL
#    )
#endif()
#
#target_link_libraries(medwhisper PRIVATE
#        android
#        log
#)
